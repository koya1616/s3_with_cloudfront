# create new security group
SG_ID=$(aws ec2 create-security-group \
  --group-name AWSCookbook205Sg \
  --description "Instance Security Group" --vpc-id $VPC_ID \
  --output text --query GroupId)

# wait for security group to be available
aws ec2 wait security-group-exists \
  --group-ids $SG_ID
echo "Security group $SG_ID is available"

aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID_1 \
--groups $SG_ID
aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID_2 \
--groups $SG_ID

aws ec2 authorize-security-group-ingress \
--protocol tcp --port 22 \
--source-group $SG_ID \
--group-id $SG_ID \

aws ec2 describe-instances --instance-ids $INSTANCE_ID_2 \
--output text \
--query Reservations[0].Instances[0].PrivateIpAddress

# nc -vz $INSTANCE_IP_2 22 is a command that checks if you can establish a connection to a specific IP address ($INSTANCE_IP_2) on port 22 (typically used for SSH) using the &#39;netcat&#39; (nc) tool.
# Here&#39;s the breakdown of the command:
# • nc: The &#39;netcat&#39; tool, used for reading from and writing to network connections.
# • -v: This option stands for &#39;verbose&#39;, meaning that it will display additional information about the connection attempt, such as the progress and any errors encountered.
# • -z: This option tells &#39;netcat&#39; to run in &#39;zero-I/O&#39; mode, which means that it doesn&#39;t send or receive any data but just checks if it can establish a connection.
# • $INSTANCE_IP_2: This is a variable representing the IP address of the instance you want to check the connection for. You should replace this with the actual IP address of the instance you want to test.
# • 22: This is the port number you want to check the connection for, in this case, port 22, which is the default port used for SSH (Secure Shell) connections.