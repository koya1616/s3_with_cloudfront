"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.S3WithCloudfrontStack = void 0;
const cdk = require("@aws-cdk/core");
const cloudfront = require("@aws-cdk/aws-cloudfront");
const origins = require("@aws-cdk/aws-cloudfront-origins");
const s3 = require("@aws-cdk/aws-s3");
class S3WithCloudfrontStack extends cdk.Stack {
    constructor(scope, id, props) {
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
                origin: new origins.S3Origin(bucket, { originAccessIdentity: oai }),
                cachePolicy: cloudfront.CachePolicy.CACHING_DISABLED, // Set this to the desired caching policy
            },
        });
        // Output the distribution domain name and the bucket domain name
        new cdk.CfnOutput(this, 'CloudFrontDomain', { value: distribution.distributionDomainName });
        new cdk.CfnOutput(this, 'BucketDomain', { value: bucket.bucketDomainName });
    }
}
exports.S3WithCloudfrontStack = S3WithCloudfrontStack;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiczNfd2l0aF9jbG91ZGZyb250LXN0YWNrLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiczNfd2l0aF9jbG91ZGZyb250LXN0YWNrLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLHFDQUFxQztBQUNyQyxzREFBc0Q7QUFDdEQsMkRBQTJEO0FBQzNELHNDQUFzQztBQUV0QyxNQUFhLHFCQUFzQixTQUFRLEdBQUcsQ0FBQyxLQUFLO0lBQ2xELFlBQVksS0FBb0IsRUFBRSxFQUFVLEVBQUUsS0FBc0I7UUFDbEUsS0FBSyxDQUFDLEtBQUssRUFBRSxFQUFFLEVBQUUsS0FBSyxDQUFDLENBQUM7UUFFeEIsc0JBQXNCO1FBQ3RCLE1BQU0sTUFBTSxHQUFHLElBQUksRUFBRSxDQUFDLE1BQU0sQ0FBQyxJQUFJLEVBQUUsWUFBWSxFQUFFO1lBQy9DLFNBQVMsRUFBRSxJQUFJO1NBQ2hCLENBQUMsQ0FBQztRQUVILHNFQUFzRTtRQUN0RSxNQUFNLEdBQUcsR0FBRyxJQUFJLFVBQVUsQ0FBQyxvQkFBb0IsQ0FBQyxJQUFJLEVBQUUsU0FBUyxFQUFFO1lBQy9ELE9BQU8sRUFBRSxzQ0FBc0M7U0FDaEQsQ0FBQyxDQUFDO1FBRUgsK0JBQStCO1FBQy9CLE1BQU0sQ0FBQyxTQUFTLENBQUMsR0FBRyxDQUFDLENBQUM7UUFFdEIsbUNBQW1DO1FBQ25DLE1BQU0sWUFBWSxHQUFHLElBQUksVUFBVSxDQUFDLFlBQVksQ0FBQyxJQUFJLEVBQUUsa0JBQWtCLEVBQUU7WUFDekUsZUFBZSxFQUFFO2dCQUNmLE1BQU0sRUFBRSxJQUFJLE9BQU8sQ0FBQyxRQUFRLENBQUMsTUFBTSxFQUFFLEVBQUMsb0JBQW9CLEVBQUUsR0FBRyxFQUFDLENBQUM7Z0JBQ2pFLFdBQVcsRUFBRSxVQUFVLENBQUMsV0FBVyxDQUFDLGdCQUFnQixFQUFFLHlDQUF5QzthQUNoRztTQUNGLENBQUMsQ0FBQztRQUVILGlFQUFpRTtRQUNqRSxJQUFJLEdBQUcsQ0FBQyxTQUFTLENBQUMsSUFBSSxFQUFFLGtCQUFrQixFQUFFLEVBQUUsS0FBSyxFQUFFLFlBQVksQ0FBQyxzQkFBc0IsRUFBRSxDQUFDLENBQUM7UUFDNUYsSUFBSSxHQUFHLENBQUMsU0FBUyxDQUFDLElBQUksRUFBRSxjQUFjLEVBQUUsRUFBRSxLQUFLLEVBQUUsTUFBTSxDQUFDLGdCQUFnQixFQUFFLENBQUMsQ0FBQztJQUM5RSxDQUFDO0NBQ0Y7QUE3QkQsc0RBNkJDIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0ICogYXMgY2RrIGZyb20gJ0Bhd3MtY2RrL2NvcmUnO1xuaW1wb3J0ICogYXMgY2xvdWRmcm9udCBmcm9tICdAYXdzLWNkay9hd3MtY2xvdWRmcm9udCc7XG5pbXBvcnQgKiBhcyBvcmlnaW5zIGZyb20gJ0Bhd3MtY2RrL2F3cy1jbG91ZGZyb250LW9yaWdpbnMnO1xuaW1wb3J0ICogYXMgczMgZnJvbSAnQGF3cy1jZGsvYXdzLXMzJztcblxuZXhwb3J0IGNsYXNzIFMzV2l0aENsb3VkZnJvbnRTdGFjayBleHRlbmRzIGNkay5TdGFjayB7XG4gIGNvbnN0cnVjdG9yKHNjb3BlOiBjZGsuQ29uc3RydWN0LCBpZDogc3RyaW5nLCBwcm9wcz86IGNkay5TdGFja1Byb3BzKSB7XG4gICAgc3VwZXIoc2NvcGUsIGlkLCBwcm9wcyk7XG5cbiAgICAvLyBDcmVhdGUgYW4gUzMgYnVja2V0XG4gICAgY29uc3QgYnVja2V0ID0gbmV3IHMzLkJ1Y2tldCh0aGlzLCAnWW91ckJ1Y2tldCcsIHtcbiAgICAgIHZlcnNpb25lZDogdHJ1ZSxcbiAgICB9KTtcblxuICAgIC8vIENyZWF0ZSBhbiBPQUkgZm9yIHJlc3RyaWN0aW5nIGJ1Y2tldCBhY2Nlc3MgdGhyb3VnaCBDbG91ZEZyb250IG9ubHlcbiAgICBjb25zdCBvYWkgPSBuZXcgY2xvdWRmcm9udC5PcmlnaW5BY2Nlc3NJZGVudGl0eSh0aGlzLCAnWW91ck9haScsIHtcbiAgICAgIGNvbW1lbnQ6ICdPQUkgZm9yIHlvdXIgQ2xvdWRmcm9udCBkaXN0cmlidXRpb24nLFxuICAgIH0pO1xuXG4gICAgLy8gR3JhbnQgcmVhZCBhY2Nlc3MgdG8gdGhlIE9BSVxuICAgIGJ1Y2tldC5ncmFudFJlYWQob2FpKTtcblxuICAgIC8vIENyZWF0ZSBhIENsb3VkRnJvbnQgZGlzdHJpYnV0aW9uXG4gICAgY29uc3QgZGlzdHJpYnV0aW9uID0gbmV3IGNsb3VkZnJvbnQuRGlzdHJpYnV0aW9uKHRoaXMsICdZb3VyRGlzdHJpYnV0aW9uJywge1xuICAgICAgZGVmYXVsdEJlaGF2aW9yOiB7XG4gICAgICAgIG9yaWdpbjogbmV3IG9yaWdpbnMuUzNPcmlnaW4oYnVja2V0LCB7b3JpZ2luQWNjZXNzSWRlbnRpdHk6IG9haX0pLFxuICAgICAgICBjYWNoZVBvbGljeTogY2xvdWRmcm9udC5DYWNoZVBvbGljeS5DQUNISU5HX0RJU0FCTEVELCAvLyBTZXQgdGhpcyB0byB0aGUgZGVzaXJlZCBjYWNoaW5nIHBvbGljeVxuICAgICAgfSxcbiAgICB9KTtcblxuICAgIC8vIE91dHB1dCB0aGUgZGlzdHJpYnV0aW9uIGRvbWFpbiBuYW1lIGFuZCB0aGUgYnVja2V0IGRvbWFpbiBuYW1lXG4gICAgbmV3IGNkay5DZm5PdXRwdXQodGhpcywgJ0Nsb3VkRnJvbnREb21haW4nLCB7IHZhbHVlOiBkaXN0cmlidXRpb24uZGlzdHJpYnV0aW9uRG9tYWluTmFtZSB9KTtcbiAgICBuZXcgY2RrLkNmbk91dHB1dCh0aGlzLCAnQnVja2V0RG9tYWluJywgeyB2YWx1ZTogYnVja2V0LmJ1Y2tldERvbWFpbk5hbWUgfSk7XG4gIH1cbn1cbiJdfQ==