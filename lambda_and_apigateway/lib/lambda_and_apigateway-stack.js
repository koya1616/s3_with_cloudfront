"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LambdaAndApigatewayStack = void 0;
const cdk = require("@aws-cdk/core");
const apigateway = require("@aws-cdk/aws-apigateway");
const lambda = require("@aws-cdk/aws-lambda");
class LambdaAndApigatewayStack extends cdk.Stack {
    constructor(scope, id, props) {
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
exports.LambdaAndApigatewayStack = LambdaAndApigatewayStack;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibGFtYmRhX2FuZF9hcGlnYXRld2F5LXN0YWNrLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsibGFtYmRhX2FuZF9hcGlnYXRld2F5LXN0YWNrLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLHFDQUFxQztBQUNyQyxzREFBc0Q7QUFDdEQsOENBQThDO0FBRTlDLE1BQWEsd0JBQXlCLFNBQVEsR0FBRyxDQUFDLEtBQUs7SUFDckQsWUFBWSxLQUFvQixFQUFFLEVBQVUsRUFBRSxLQUFzQjtRQUNsRSxLQUFLLENBQUMsS0FBSyxFQUFFLEVBQUUsRUFBRSxLQUFLLENBQUMsQ0FBQztRQUV4Qiw2QkFBNkI7UUFDN0IsTUFBTSxXQUFXLEdBQUcsSUFBSSxNQUFNLENBQUMsUUFBUSxDQUFDLElBQUksRUFBRSxhQUFhLEVBQUU7WUFDM0QsT0FBTyxFQUFFLE1BQU0sQ0FBQyxPQUFPLENBQUMsV0FBVztZQUNuQyxPQUFPLEVBQUUsZUFBZTtZQUN4QixJQUFJLEVBQUUsTUFBTSxDQUFDLElBQUksQ0FBQyxVQUFVLENBQUM7Ozs7Ozs7OztPQVM1QixDQUFDO1NBQ0gsQ0FBQyxDQUFDO1FBRUgseUJBQXlCO1FBQ3pCLE1BQU0sR0FBRyxHQUFHLElBQUksVUFBVSxDQUFDLGFBQWEsQ0FBQyxJQUFJLEVBQUUsVUFBVSxFQUFFO1lBQ3pELE9BQU8sRUFBRSxXQUFXO1lBQ3BCLEtBQUssRUFBRSxLQUFLO1NBQ2IsQ0FBQyxDQUFDO1FBRUgsa0RBQWtEO1FBQ2xELE1BQU0sWUFBWSxHQUFHLEdBQUcsQ0FBQyxJQUFJLENBQUMsV0FBVyxDQUFDLE9BQU8sQ0FBQyxDQUFDO1FBQ25ELFlBQVksQ0FBQyxTQUFTLENBQUMsS0FBSyxDQUFDLENBQUM7UUFDOUIsc0RBQXNEO1FBQ3RELE1BQU0sWUFBWSxHQUFHLEdBQUcsQ0FBQyxJQUFJLENBQUMsV0FBVyxDQUFDLE1BQU0sQ0FBQyxDQUFDO1FBQ2xELFlBQVksQ0FBQyxTQUFTLENBQUMsS0FBSyxDQUFDLENBQUM7SUFDaEMsQ0FBQztDQUNGO0FBakNELDREQWlDQyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCAqIGFzIGNkayBmcm9tICdAYXdzLWNkay9jb3JlJztcbmltcG9ydCAqIGFzIGFwaWdhdGV3YXkgZnJvbSAnQGF3cy1jZGsvYXdzLWFwaWdhdGV3YXknO1xuaW1wb3J0ICogYXMgbGFtYmRhIGZyb20gJ0Bhd3MtY2RrL2F3cy1sYW1iZGEnO1xuXG5leHBvcnQgY2xhc3MgTGFtYmRhQW5kQXBpZ2F0ZXdheVN0YWNrIGV4dGVuZHMgY2RrLlN0YWNrIHtcbiAgY29uc3RydWN0b3Ioc2NvcGU6IGNkay5Db25zdHJ1Y3QsIGlkOiBzdHJpbmcsIHByb3BzPzogY2RrLlN0YWNrUHJvcHMpIHtcbiAgICBzdXBlcihzY29wZSwgaWQsIHByb3BzKTtcbiAgICBcbiAgICAvLyBDcmVhdGUgdGhlIExhbWJkYSBmdW5jdGlvblxuICAgIGNvbnN0IGhlbGxvTGFtYmRhID0gbmV3IGxhbWJkYS5GdW5jdGlvbih0aGlzLCAnaGVsbG9MYW1iZGEnLCB7XG4gICAgICBydW50aW1lOiBsYW1iZGEuUnVudGltZS5OT0RFSlNfMTRfWCxcbiAgICAgIGhhbmRsZXI6ICdpbmRleC5oYW5kbGVyJyxcbiAgICAgIGNvZGU6IGxhbWJkYS5Db2RlLmZyb21JbmxpbmUoYFxuICAgICAgICBleHBvcnRzLmhhbmRsZXIgPSBhc3luYyAoZXZlbnQpID0+IHtcbiAgICAgICAgICAgIHJldHVybiB7XG4gICAgICAgICAgICAgICAgc3RhdHVzQ29kZTogMjAwLFxuICAgICAgICAgICAgICAgIGJvZHk6IEpTT04uc3RyaW5naWZ5KHtcbiAgICAgICAgICAgICAgICAgICAgbWVzc2FnZTogJ0hlbGxvLCBDREshJ1xuICAgICAgICAgICAgICAgIH0pLFxuICAgICAgICAgICAgfTtcbiAgICAgICAgfTtcbiAgICAgIGApXG4gICAgfSk7XG5cbiAgICAvLyBDcmVhdGUgdGhlIEFQSSBHYXRld2F5XG4gICAgY29uc3QgYXBpID0gbmV3IGFwaWdhdGV3YXkuTGFtYmRhUmVzdEFwaSh0aGlzLCAnaGVsbG9BcGknLCB7XG4gICAgICBoYW5kbGVyOiBoZWxsb0xhbWJkYSxcbiAgICAgIHByb3h5OiBmYWxzZVxuICAgIH0pO1xuXG4gICAgLy8gQ3JlYXRlIGEgcm9vdCByZXNvdXJjZSBhbmQgY29uZmlndXJlIHRoZSBtZXRob2RcbiAgICBjb25zdCByb290UmVzb3VyY2UgPSBhcGkucm9vdC5hZGRSZXNvdXJjZSgnaGVsbG8nKTtcbiAgICByb290UmVzb3VyY2UuYWRkTWV0aG9kKCdHRVQnKTtcbiAgICAvLyBDcmVhdGUgYSBnb29kIHJlc291cmNlIGFuZCBjb25maWd1cmUgdGhlIEdFVCBtZXRob2RcbiAgICBjb25zdCBnb29kUmVzb3VyY2UgPSBhcGkucm9vdC5hZGRSZXNvdXJjZSgnZ29vZCcpO1xuICAgIGdvb2RSZXNvdXJjZS5hZGRNZXRob2QoJ0dFVCcpO1xuICB9XG59Il19