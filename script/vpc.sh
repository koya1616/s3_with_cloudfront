VPC_ID=$(aws ec2 create-vpc --cidr-block 10.10.0.0/23 \
--tag-specifications \
--output text --query Vpc.VpcId)
echo "Created VPC with ID: $VPC_ID"

ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID \
--tag-specifications \
--output text --query RouteTable.RouteTableId)
echo "Created Route Table with ID: $ROUTE_TABLE_ID"

SUBNET_ID_1=$(aws ec2 create-subnet --vpc-id $VPC_ID \
--cidr-block 10.10.0.0/24 --availability-zone ap-northeast-1a \
--output text --query Subnet.SubnetId)
echo "Created Subnet with ID: $SUBNET_ID_1"

SUBNET_ID_2=$(aws ec2 create-subnet --vpc-id $VPC_ID \
--cidr-block 10.10.1.0/24 --availability-zone ap-northeast-1b \
--output text --query Subnet.SubnetId)
echo "Created Subnet with ID: $SUBNET_ID_2"

aws ec2 associate-route-table \
--route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_1

aws ec2 associate-route-table \
--route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_2

aws ec2 describe-subnets --subnet-ids $SUBNET_ID_1

aws ec2 describe-subnets --subnet-ids $SUBNET_ID_2

aws ec2 describe-route-tables --route-table-ids $ROUTE_TABLE_ID

aws ec2 delete-subnet --subnet-id $SUBNET_ID_1

aws ec2 delete-subnet --subnet-id $SUBNET_ID_2

aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID

aws ec2 delete-vpc --vpc-id $VPC_ID