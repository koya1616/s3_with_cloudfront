import * as cdk from '@aws-cdk/core';
import * as apigateway from '@aws-cdk/aws-apigateway';
import * as lambda from '@aws-cdk/aws-lambda';

export class LambdaAndApigatewayStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    
    // Create the Lambda function
    const helloLambda = new lambda.Function(this, 'helloLambda', {
      runtime: lambda.Runtime.NODEJS_14_X,
      handler: 'index.handler',
      code: lambda.Code.fromInline(`
        exports.handler = async (event) => {
            return {
                statusCode: 200,
                body: JSON.stringify({
                    message: 'Hello, CDK!'
                }),
            };
        };
      `)
    });

    // Create the API Gateway
    const api = new apigateway.LambdaRestApi(this, 'helloApi', {
      handler: helloLambda,
      proxy: false
    });

    // Create a root resource and configure the method
    const rootResource = api.root.addResource('hello');
    rootResource.addMethod('GET');
    // Create a good resource and configure the GET method
    const goodResource = api.root.addResource('good');
    goodResource.addMethod('GET');
  }
}