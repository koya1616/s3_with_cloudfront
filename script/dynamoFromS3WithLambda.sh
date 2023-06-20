aws dynamodb create-table \
--table-name 'AWSCookbook507' \
--attribute-definitions 'AttributeName=UserID,AttributeType=S' \
--key-schema 'AttributeName=UserID,KeyType=HASH' \
--sse-specification 'Enabled=true,SSEType=KMS' \
--provisioned-throughput 'ReadCapacityUnits=5,WriteCapacityUnits=5'

# wait for table to be created
aws dynamodb wait table-exists --table-name 'AWSCookbook507'

# show status of table
aws dynamodb describe-table --table-name 'AWSCookbook507'

RANDOM_STRING=$(aws secretsmanager get-random-password \
--exclude-punctuation --exclude-uppercase \
--password-length 6 --require-each-included-type \
--output text \
--query RandomPassword)

aws s3api create-bucket --bucket awscookbook507-$RANDOM_STRING

aws iam create-role --role-name AWSCookbook507Lambda \
--assume-role-policy-document file://assume-role-policy.json

aws iam attach-role-policy --role-name AWSCookbook507Lambda \
--policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

aws iam attach-role-policy --role-name AWSCookbook507Lambda \
--policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess

aws iam attach-role-policy --role-name AWSCookbook507Lambda \
--policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

LAMBDA_ARN=$(aws lambda create-function \
--function-name AWSCookbook507Lambda \
--runtime python3.8 \
--package-type "Zip" \
--zip-file fileb://lambda_function.zip \
--handler lambda_function.lambda_handler --publish \
--environment Variables={bucket=awscookbook507-$RANDOM_STRING} \
--role arn:aws:iam::$AWS_ACCOUNT_ID:role/AWSCookbook507Lambda \
--output text --query FunctionArn)

aws lambda add-permission --function-name $LAMBDA_ARN \
--action lambda:InvokeFunction --statement-id s3invoke \
--principal s3.amazonaws.com

sed -e "s/LAMBDA_ARN/${LAMBDA_ARN}/g" notification-template.json > notification.json

aws s3api put-bucket-notification-configuration \
--bucket awscookbook507-$RANDOM_STRING \
--notification-configuration file://notification.json

aws s3 cp ./sample_data.csv s3://awscookbook507-$RANDOM_STRING

# Validation checks
aws dynamodb scan --table-name AWSCookbook507