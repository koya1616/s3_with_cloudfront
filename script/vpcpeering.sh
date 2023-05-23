VPC_PEERING_CONNECTION_ID=$(aws ec2 create-vpc-peering-connection \
--vpc-id $VPC_ID_1 --peer-vpc-id $VPC_ID_2 --output text \
--query VpcPeeringConnection.VpcPeeringConnectionId)
# wait for the VPC peering connection to be established
aws ec2 wait vpc-peering-connection-exists \
--vpc-peering-connection-ids $VPC_PEERING_CONNECTION_ID

aws ec2 accept-vpc-peering-connection \
--vpc-peering-connection-id $VPC_PEERING_CONNECTION_ID

aws ec2 create-route --route-table-id $VPC_SUBNET_RT_ID_1 \
--destination-cidr-block $VPC_CIDR_2 \
--vpc-peering-connection-id $VPC_PEERING_CONNECTION_ID

aws ec2 create-route --route-table-id $VPC_SUBNET_RT_ID_2 \
--destination-cidr-block $VPC_CIDR_1 \
--vpc-peering-connection-id $VPC_PEERING_CONNECTION_ID

aws ec2 authorize-security-group-ingress \
--protocol icmp --port -1 \
--source-group $INSTANCE_SG_1 \
--group-id $INSTANCE_SG_2