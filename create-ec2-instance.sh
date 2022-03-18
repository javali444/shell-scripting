#!/bin/bash

if [ -z "$1" ]; then
    echo -e "\e[31mInput machine name\e[0m"
    exit 1
fi

Component=$1


AMI_ID=$( aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')

SEC_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=allow-all-from-public" | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')

private_ip=$(aws ec2 run-instances \
    --image-id ${AMI_ID} \
    --instance-type t2.micro \
    --security-group-ids ${SEC_ID} \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${Component}}]" \
    --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
    | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')


sed -e "s/COMPONENT/${Component}" -e "s/IPaddress/${private_ip}" route53.json &>> /tmp/DNS_log.json

aws route53 change-resource-record-sets --hosted-zone-id Z051954137QLHFOEJ46UR --change-batch file:///tmp/DNS_log.json | jq