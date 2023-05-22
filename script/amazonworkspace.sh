curl -o ip-ranges.json https://ip-ranges.amazonaws.com/ip-ranges.json

PREFIX_LIST_ID=$(aws ec2 create-managed-prefix-list \
--address-family IPv4 \
--max-entries 15 \
--prefix-list-name allowed-us-east-1-cidrs \
--output text --query "PrefixList.PrefixListId" \
--entries Cidr=44.234.54.0/23,Description=workspaces-us-west-2-cidr1 Cidr=54.244.46.0/23,Description=workspaces-us-west-2-cidr2)

#wait for prefix list to be available
aws ec2 wait prefix-list-available \
--prefix-list-id $PREFIX_LIST_ID

MY_IP_4=$(curl myip4.com | tr -d ' ')

aws ec2 modify-managed-prefix-list \
--prefix-list-id $PREFIX_LIST_ID \
--current-version 1 \
--add-entries Cidr=${MY_IP_4}/32,Description=my-workstation-ip

aws ec2 authorize-security-group-ingress \
--group-id $INSTANCE_SG_1 --ip-permissions \
IpProtocol=tcp,FromPort=80,ToPort=80,PrefixListIds="[{Description=http-from-prefix-list,PrefixListId=$PREFIX_LIST_ID}]"
aws ec2 authorize-security-group-ingress \
--group-id $INSTANCE_SG_2 --ip-permissions \
IpProtocol=tcp,FromPort=80,ToPort=80,PrefixListIds="[{Description=http-from-prefix-list,PrefixListId=$PREFIX_LIST_ID}]"

aws ec2 get-managed-prefix-list-associations --prefix-list-id $PREFIX_LIST_ID