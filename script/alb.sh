openssl genrsa 2048 > my-private-key.pem

openssl req -new -x509 -nodes -sha256 -days 365 \
-key my-private-key.pem -outform PEM -out my-certificate.pem

CERT_ARN=$(aws iam upload-server-certificate \
--server-certificate-name AWSCookbook207 \
--certificate-body file://my-certificate.pem \
--private-key file://my-private-key.pem \
--query ServerCertificateMetadata.Arn --output text)
#wait for certificate to be available
aws iam wait server-certificate-exists \
--server-certificate-name AWSCookbook207
echo "Certificate $CERT_ARN is available"

ALB_SG_ID=$(aws ec2 create-security-group --group-name Cookbook207SG \
--description "ALB Security Group" --vpc-id $VPC_ID \
--output text --query GroupId)
# wait for security group to be available
aws ec2 wait security-group-exists --group-ids $ALB_SG_ID
echo "Security group $ALB_SG_ID is available"

aws ec2 authorize-security-group-ingress \
--protocol tcp --port 443 \
--cidr '0.0.0.0/0' \
--group-id $ALB_SG_ID
aws ec2 authorize-security-group-ingress \
--protocol tcp --port 80 \
--cidr '0.0.0.0/0' \
--group-id $ALB_SG_ID

aws ec2 authorize-security-group-ingress \
--protocol tcp --port 80 \
--source-group $ALB_SG_ID \
--group-id $APP_SG_ID


LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer \
--name aws-cookbook207-alb \
--subnets $VPC_PUBLIC_SUBNETS --security-groups $ALB_SG_ID \
--scheme internet-facing \
--output text --query LoadBalancers[0].LoadBalancerArn)
# wait for load balancer to be available
aws elbv2 wait load-balancer-available \
--load-balancer-arns $LOAD_BALANCER_ARN
echo "Load balancer $LOAD_BALANCER_ARN is available"

TARGET_GROUP=$(aws elbv2 create-target-group \
--name aws-cookbook207-tg --vpc-id $VPC_ID \
--protocol HTTP --port 80 --target-type ip \
--query "TargetGroups[0].TargetGroupArn" \
--output text)
# wait for target group to be available
aws elbv2 wait target-group-exists \
--target-group-arns $TARGET_GROUP

TASK_ARN=$(aws ecs list-tasks --cluster $ECS_CLUSTER_NAME \
--output text --query taskArns)
CONTAINER_IP=$(aws ecs describe-tasks --cluster $ECS_CLUSTER_NAME \
--task $TASK_ARN --output text \
--query tasks[0].attachments[0].details[4] | cut -f 2)

aws elbv2 register-targets --targets Id=$CONTAINER_IP --target-group-arn $TARGET_GROUP

HTTPS_LISTENER_ARN=$(aws elbv2 create-listener \
--load-balancer-arn $LOAD_BALANCER_ARN \
--protocol HTTPS --port 443 \
--certificates CertificateArn=$CERT_ARN \
--default-actions Type=forward,TargetGroupArn=$TARGET_GROUP \
--output text --query Listeners[0].ListenerArn)
# wait for listener to be available
aws elbv2 wait listener-exists \
--listener-arn $HTTPS_LISTENER_ARN
echo "Listener $HTTPS_LISTENER_ARN is available"

aws elbv2 create-rule \
--listener-arn $HTTPS_LISTENER_ARN \
--priority 10 \
--conditions '{"Field":"path-pattern","PathPatternConfig":{"Values":["/*"]}}' \
--actions Type=forward,TargetGroupArn=$TARGET_GROUP
# wait for rule to be available
aws elbv2 wait rule-exists \
--listener-arn $HTTPS_LISTENER_ARN \
--query Rules[0].RuleArn
echo "Rule $HTTPS_LISTENER_ARN is available"

aws elbv2 create-listener --load-balancer-arn
$LOAD_BALANCER_ARN \
--protocol HTTP --port 80 \
--default-actions \
"Type=redirect,RedirectConfig={Protocol=HTTPS,Port=443,Host='#{host}',Query='#{query}',Path='/#{path}',StatusCode=HTTP_301}"
# wait for listener to be available
aws elbv2 wait listener-exists \
--listener-arn $HTTPS_LISTENER_ARN
echo "Listener $HTTPS_LISTENER_ARN is available"

aws elbv2 describe-target-health --target-group-arn $TARGET_GROUP \
--query TargetHealthDescriptions[*].TargetHealth.State


LOAD_BALANCER_DNS=$(aws elbv2 describe-load-balancers \
--names aws-cookbook207-alb \
--output text --query LoadBalancers[0].DNSName)
echo "Load balancer DNS name is $LOAD_BALANCER_DNS"