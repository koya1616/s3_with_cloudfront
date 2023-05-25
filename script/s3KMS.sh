RANDOM_STRING=$(aws secretsmanager get-random-password \
--exclude-punctuation --exclude-uppercase \
--password-length 6 --require-each-included-type \
--output text \
--query RandomPassword)

aws s3api create-bucket --bucket awscookbook306-$RANDOM_STRING \
--create-bucket-configuration LocationConstraint=ap-northeast-1

# wait for the bucket to be created
aws s3api wait bucket-exists --bucket awscookbook306-$RANDOM_STRING

KEY_ID=$(aws kms create-key \
--tags TagKey=Name,TagValue=AWSCookbook306Key \
--description "AWSCookbook S3 CMK" \
--query KeyMetadata.KeyId \
--output text)
echo $KEY_ID

# wait for the key to be created
aws kms wait key-exists --key-id $KEY_ID

aws kms create-alias \
--alias-name alias/awscookbook306 \
--target-key-id $KEY_ID

aws s3api put-bucket-encryption \
--bucket awscookbook306-$RANDOM_STRING \
--server-side-encryption-configuration '{
    "Rules": [ {
        "ApplyServerSideEncryptionByDefault": {
            "SSEAlgorithm": "aws:kms",
            "KMSMasterKeyID": "${KEY_ID}"
        },
        "BucketKeyEnabled": true
    } ]
}'

sed -i "s/BUCKET_NAME/awscookbook306-${RANDOM_STRING}/g" bucket-policy.json

aws s3api put-bucket-policy --bucket awscookbook306-$RANDOM_STRING \
--policy file://bucket-policy.json