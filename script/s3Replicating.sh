RANDOM_STRING=$(aws secretsmanager get-random-password \
--exclude-punctuation --exclude-uppercase \
--password-length 6 --require-each-included-type \
--output text \
--query RandomPassword)

aws s3api create-bucket --bucket awscookbook303-src-$RANDOM_STRING \
--create-bucket-configuration LocationConstraint=ap-northeast-1
# wait for bucket to be created
aws s3api wait bucket-exists --bucket awscookbook303-src-$RANDOM_STRING

aws s3api put-bucket-versioning \
--bucket awscookbook303-src-$RANDOM_STRING \
--versioning-configuration Status=Enabled

aws s3api create-bucket --bucket awscookbook303-dst-$RANDOM_STRING \
--create-bucket-configuration LocationConstraint=ap-northeast-1
# wait for bucket to be created
aws s3api wait bucket-exists --bucket awscookbook303-dst-$RANDOM_STRING

aws s3api put-bucket-versioning \
--bucket awscookbook303-dst-$RANDOM_STRING \
--versioning-configuration Status=Enabled

### JSONを扱う前は、sedコマンドを使おうぜい！

ROLE_ARN=$(aws iam create-role --role-name AWSCookbook303S3Role \
--assume-role-policy-document file://s3-assume-role-policy.json \
--output text --query Role.Arn)
# wait for role to be created
aws iam wait role-exists --role-name AWSCookbook303S3Role

aws iam put-role-policy \
--role-name AWSCookbook303S3Role \
--policy-document file://s3-perms-policy.json \
--policy-name S3ReplicationPolicy

aws s3api put-bucket-replication \
--replication-configuration file://s3-replication.json \
--bucket awscookbook303-src-$RANDOM_STRING