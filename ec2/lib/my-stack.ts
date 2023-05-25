import * as cdk from '@aws-cdk/core';
import * as ec2 from '@aws-cdk/aws-ec2';
import * as efs from '@aws-cdk/aws-efs';

export class MyStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Create the VPC with isolated subnets
    const vpc = new ec2.Vpc(this, 'MyVpc', {
      maxAzs: 1,
      subnetConfiguration: [
        {
          subnetType: ec2.SubnetType.PRIVATE_ISOLATED,
          cidrMask: 24,
          name: 'IsolatedSubnets',
        },
      ],
    });

    // Create the route table for the isolated subnets
    const routeTable = new ec2.CfnRouteTable(this, 'RouteTable', {
      vpcId: vpc.vpcId,
    });

    // Associate the route table with the isolated subnets
    vpc.isolatedSubnets.forEach((subnet, index) => {
      new ec2.CfnSubnetRouteTableAssociation(this, `RouteTableAssociation${index}`, {
        subnetId: subnet.subnetId,
        routeTableId: routeTable.ref,
      });
    });

    // EFS のセキュリティグループを作成
    const efsSg = new ec2.SecurityGroup(this, 'MyEfsSecurityGroup', {
      vpc: vpc,
      allowAllOutbound: true,
    });

    // セキュリティグループのインバウンドルールを設定して、EFS アクセスを許可
    efsSg.addIngressRule(ec2.Peer.anyIpv4(), ec2.Port.tcp(2049), 'Allow EFS access');

    // Create an EC2 instance in the isolated subnet
    new ec2.Instance(this, 'MyInstance', {
      vpc: vpc,
      instanceType: new ec2.InstanceType('t2.micro'),
      machineImage: new ec2.AmazonLinuxImage({
        generation: ec2.AmazonLinuxGeneration.AMAZON_LINUX_2,
      }),
      vpcSubnets: { subnetType: ec2.SubnetType.PRIVATE_ISOLATED },
      securityGroup: efsSg,
    });
  }
}