END_POINT_ID=$(aws ec2 create-vpc-endpoint \
--vpc-id $VPC_ID \
--service-name com.amazonaws.$AWS_REGION.s3 \
--route-table-ids $RT_ID_1 $RT_ID_2 \
--query VpcEndpoint.VpcEndpointId --output text)