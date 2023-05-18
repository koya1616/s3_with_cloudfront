import * as cdk from '@aws-cdk/core';
import * as cloudfront from '@aws-cdk/aws-cloudfront';
import * as origins from '@aws-cdk/aws-cloudfront-origins';
import * as s3 from '@aws-cdk/aws-s3';

export class S3WithCloudfrontStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Create an S3 bucket
    const bucket = new s3.Bucket(this, 'YourBucket', {
      versioned: true,
    });

    // Create an OAI for restricting bucket access through CloudFront only
    const oai = new cloudfront.OriginAccessIdentity(this, 'YourOai', {
      comment: 'OAI for your Cloudfront distribution',
    });

    // Grant read access to the OAI
    bucket.grantRead(oai);

    // Create a CloudFront distribution
    const distribution = new cloudfront.Distribution(this, 'YourDistribution', {
      defaultBehavior: {
        origin: new origins.S3Origin(bucket, {originAccessIdentity: oai}),
        cachePolicy: cloudfront.CachePolicy.CACHING_DISABLED, // Set this to the desired caching policy
      },
    });

    // Output the distribution domain name and the bucket domain name
    new cdk.CfnOutput(this, 'CloudFrontDomain', { value: distribution.distributionDomainName });
    new cdk.CfnOutput(this, 'BucketDomain', { value: bucket.bucketDomainName });
  }
}
