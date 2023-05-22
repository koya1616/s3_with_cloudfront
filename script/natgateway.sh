ALLOCATION_ID=$(aws ec2 allocate-address --domain vpc \
  --output text --query AllocationId)
echo "Allocation ID: $ALLOCATION_ID"

# Wait for allocate-address to be available
aws ec2 wait address-allocated \
  --allocation-ids $ALLOCATION_ID

NAT_GATEWAY_ID=$(aws ec2 create-nat-gateway \
  --subnet-id $VPC_PUBLIC_SUBNET_1 \
  --allocation-id $ALLOCATION_ID \
  --output text --query NatGateway.NatGatewayId)
echo "NAT Gateway ID: $NAT_GATEWAY_ID"

# Wait for NAT Gateway to be available
aws ec2 wait nat-gateway-available \
  --nat-gateway-ids $NAT_GATEWAY_ID

aws ec2 describe-nat-gateways \
  --nat-gateway-ids $NAT_GATEWAY_ID \
  --output text --query NatGateways[0].State

aws ec2 create-route --route-table-id $PRIVATE_RT_ID_1 \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id $NAT_GATEWAY_ID

# wait for route to be available
aws ec2 wait route-table-available \
  --route-table-id $PRIVATE_RT_ID_1
echo "Route table $PRIVATE_RT_ID_1 is available"

aws ec2 create-route --route-table-id $PRIVATE_RT_ID_2 \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id $NAT_GATEWAY_ID

# wait for route to be available
aws ec2 wait route-table-available \
  --route-table-id $PRIVATE_RT_ID_2
echo "Route table $PRIVATE_RT_ID_2 is available"