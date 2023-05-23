TGW_ID=$(aws ec2 create-transit-gateway \
--description AWSCookbook210 \
—-options=AmazonSideAsn=65010,AutoAcceptSharedAttachments=enable,DefaultRouteTableAssociation=enable,\
DefaultRouteTablePropagation=enable,VpnEcmpSupport=enable,DnsSupport=enable \
--output text --query TransitGateway.TransitGatewayId)
# wait for the TGW to be available
aws ec2 wait transit-gateway-available --transit-gateway-ids $TGW_ID

aws ec2 describe-transit-gateways \
--transit-gateway-ids $TGW_ID \
--output text --query TransitGateways[0].State

TGW_ATTACH_1=$(aws ec2 create-transit-gateway-vpc-attachment \
--transit-gateway-id $TGW_ID \
--vpc-id $VPC_ID_1 \
--subnet-ids $ATTACHMENT_SUBNETS_VPC_1 \
--query TransitGatewayVpcAttachment.TransitGatewayAttachmentId \
--output text)

TGW_ATTACH_2=$(aws ec2 create-transit-gateway-vpc-attachment\
--transit-gateway-id $TGW_ID \
--vpc-id $VPC_ID_2 \
--subnet-ids $ATTACHMENT_SUBNETS_VPC_2 \
--query TransitGatewayVpcAttachment.TransitGatewayAttachmentId \
--output text)

TGW_ATTACH_3=$(aws ec2 create-transit-gateway-vpc-attachment \
--transit-gateway-id $TGW_ID \
--vpc-id $VPC_ID_3 \
--subnet-ids $ATTACHMENT_SUBNETS_VPC_3 \
--query TransitGatewayVpcAttachment.TransitGatewayAttachmentId \
--output text)

aws ec2 create-route --route-table-id $VPC_1_RT_ID_1 \
--destination-cidr-block 0.0.0.0/0 \
--transit-gateway-id $TGW_ID

aws ec2 create-route --route-table-id $VPC_1_RT_ID_2 \
--destination-cidr-block 0.0.0.0/0 \
--transit-gateway-id $TGW_ID

aws ec2 create-route --route-table-id $VPC_3_RT_ID_1 \
--destination-cidr-block 0.0.0.0/0 \
--transit-gateway-id $TGW_ID

aws ec2 create-route --route-table-id $VPC_3_RT_ID_2 \
--destination-cidr-block 0.0.0.0/0 \
--transit-gateway-id $TGW_ID

aws ec2 create-route --route-table-id $VPC_2_RT_ID_1 \
--destination-cidr-block 10.10.0.0/24 \
--transit-gateway-id $TGW_ID

aws ec2 create-route --route-table-id $VPC_2_RT_ID_2 \
--destination-cidr-block 10.10.0.0/24 \
--transit-gateway-id $TGW_ID


NAT_GW_ID_1=$(aws ec2 describe-nat-gateways \
--filter "Name=subnet-id,Values=$VPC_2_PUBLIC_SUBNET_ID_1" \
--output text --query NatGateways[*].NatGatewayId)

NAT_GW_ID_2=$(aws ec2 describe-nat-gateways \
--filter "Name=subnet-id,Values=$VPC_2_PUBLIC_SUBNET_ID_2" \
--output text --query NatGateways[*].NatGatewayId)

aws ec2 create-route --route-table-id $VPC_2_ATTACH_RT_ID_1 \
--destination-cidr-block 0.0.0.0/0 \
--nat-gateway-id $NAT_GW_ID_1

aws ec2 create-route --route-table-id $VPC_2_ATTACH_RT_ID_2 \
--destination-cidr-block 0.0.0.0/0 \
--nat-gateway-id $NAT_GW_ID_2

aws ec2 create-route --route-table-id $VPC_2_PUBLIC_RT_ID_1 \
--destination-cidr-block 10.10.0.0/24 \
--transit-gateway-id $TGW_ID

aws ec2 create-route --route-table-id $VPC_2_PUBLIC_RT_ID_2 \
--destination-cidr-block 10.10.0.0/24 \
--transit-gateway-id $TGW_ID

TRAN_GW_RT=$(aws ec2 describe-transit-gateways \
--transit-gateway-ids $TGW_ID --output text \
--query TransitGateways[0].Options.AssociationDefaultRouteTableId)

aws ec2 create-transit-gateway-route \
--destination-cidr-block 0.0.0.0/0 \
--transit-gateway-route-table-id $TRAN_GW_RT \
--transit-gateway-attachment-id $TGW_ATTACH_2