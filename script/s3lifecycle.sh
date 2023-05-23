RANDOM_STRING=$(aws secretsmanager get-random-password \
--exclude-punctuation --exclude-uppercase \
--password-length 6 --require-each-included-type \
--output text \
--query RandomPassword)
echo $RANDOM_STRING

aws s3api create-bucket --bucket awscookbook301-$RANDOM_STRING \
--create-bucket-configuration LocationConstraint=ap-northeast-1

# wait for the bucket to be created
aws s3api wait bucket-exists --bucket awscookbook301-$RANDOM_STRING

aws s3api put-bucket-lifecycle-configuration \
--bucket awscookbook301-$RANDOM_STRING \
--lifecycle-configuration file://lifecycle-rule.json

aws s3api get-bucket-lifecycle-configuration \
--bucket awscookbook301-$RANDOM_STRING