#!/bin/bash

AMI_ID=$( aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')

SEC_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=allow-all-from-public" | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g'")

aws ec2 run-instances \
    --image-id ${AMI_ID} --instance-type t2.micro \
    --security-group-ids ${SEC_ID}