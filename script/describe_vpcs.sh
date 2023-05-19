#!/bin/bash

# VPCを作成し、VPCIDを取得
VPCID=$(aws ec2 create-vpc --cidr-block 10.10.0.0/16 --output text --query Vpc.VpcId)
echo "Created VPC with ID: $VPCID"

# 作成されたVPCの詳細情報を表示
aws ec2 describe-vpcs --vpc-ids $VPCID