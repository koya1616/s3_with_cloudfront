import * as cdk from '@aws-cdk/core';
import * as ec2 from '@aws-cdk/aws-ec2';
import * as s3 from '@aws-cdk/aws-s3';

export class MyStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Create a VPC
    const vpc = new ec2.Vpc(this, 'MyVpc', {
      cidr: '10.0.0.0/16', // Choose any CIDR you prefer for your VPC
      maxAzs: 2, // Availability zones
      natGateways: 0, // No NAT gateway as we don't need it for this example
    });

    // Create an S3 bucket
    const bucket = new s3.Bucket(this, 'MyBucket', {
      versioned: true,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });

    // Create a security group for the EC2 instance
    const sg = new ec2.SecurityGroup(this, 'MySG', {
      vpc,
    });

    // Open port 22 for SSH
    sg.addIngressRule(ec2.Peer.anyIpv4(), ec2.Port.tcp(22), 'allow SSH');

    // Create an EC2 instance
    new ec2.Instance(this, 'MyEC2', {
      vpc,
      instanceType: ec2.InstanceType.of(ec2.InstanceClass.T2, ec2.InstanceSize.MICRO),
      machineImage: new ec2.AmazonLinuxImage(),
      securityGroup: sg,
    });

    // Create a VPC gateway endpoint to S3
    vpc.addGatewayEndpoint('S3GatewayEndpoint', {
      service: ec2.GatewayVpcEndpointAwsService.S3,
    });
  }
}