---
layout: post
title: Get Started with AWS SAM and ASP.NET Core
description: Show you how to use AWS SAM to host a serverless ASP.NET Core website or API
tags:
  - aws
  - asp.net
  - serverless
---

[AWS Serverless Application Model](https://aws.amazon.com/serverless/sam/) (a.k.a SAM) is the bundling some AWS services such as APIGateway, Lambda and DynamoDB, etc and also AWS provides tools to help developers easier develop serverless applications. AWS SAM supports many programming languages such as nodejs, go, python, etc. However, in this article, I used dotnet and its web framework ASP.NET Core to demonstrate. The reason I chose dotnet rather than I am familiar with dotnet, it is also because AWS officially provides other tools for dotnet. These tools makes development easier than other programming languages (at least it is how I have felt).

## Why Use Serverless Applications?

There are many benefits of serverless applications such as cheaper. Unlike normal web application, it have to run 7/24. On the other hand, serverless applications only run on-demand. If no one is calling your web application, you almost pay nothing. The below figures are based on [AWS Pricing Calculator](https://calculator.aws/)

For monthly payment,
Serverless Applications

- 0 requests, the payment is about $0 USD
- 10,000 request, the payment is about $1 USD
- 1,000,000 requests, the payment is about $10 USD

Applications on EC2

- 0 requests, the payment is about $10 USD for 1 t2.micro
- 10,000 requests, the payment is about $10 USD for 1 t2.micro
- 1,000,000 requests, the payment is about $100 USD for 1 t4g.large

It is a huge cutting for a small web application.

> NOTE: These figures only compared Lambda and APIGateway to EC2. There might be other fees like for Route53 and S3. Also, the lambda is set to run 2000 ms and use 256 MB memory.

## Requirements

These are the requirements
- A AWS Account
    - you don't needs to install AWS-CLI in order to run SAM, but you need to put AWS credential either in Environment Variables or ~/.aws/credentials
- A AWS Bucket
    - the code will push to the bucket
- [.NET Core 3.1 SDK](https://dotnet.microsoft.com/download)
    - At the time I wrote this article, AWS Lambda doesn't supports .NET 5 or 6 unless you use Container, but it is out of the topic of this article.
- [Amazon.Lambda.Tools and Templates](https://github.com/aws/aws-lambda-dotnet)

After .NET SDK is installed, run the below commands to install lambda tools and templates.

```bash
# install lambda tools
dotnet tool install --global Amazon.Lambda.Tools

# install templates
dotnet new -i "Amazon.Lambda.Templates::*"

# you can run this command to list the lambda templates
dotnet new serverless --list
```

These are the templates for serverless

```text
Templates                                             Short Name
----------------------------------------------------  ----------------------------------
Lambda ASP.NET Core Web API                           serverless.AspNetCoreWebAPI
Lambda ASP.NET Core Web API (.NET 5 Container Image)  serverless.image.AspNetCoreWebAPI
Lambda ASP.NET Core Web Application with Razor Pages  serverless.AspNetCoreWebApp
Serverless Detect Image Labels                        serverless.DetectImageLabels
Lambda DynamoDB Blog API                              serverless.DynamoDBBlogAPI
Lambda Empty Serverless                               serverless.EmptyServerless
Lambda Empty Serverless (.NET 5 Container Image)      serverless.image.EmptyServerless
Lambda Giraffe Web App                                serverless.Giraffe
Serverless Simple S3 Function                         serverless.S3
Step Functions Hello World                            serverless.StepFunctionsHelloWorld
Serverless WebSocket API                              serverless.WebSocketAPI
```

## Create a Serverless Application

We will use `serverless.AspNetCoreWebAPI` because it won't generate too much or too less files.
We can run this command to create MyFirstSAM project

```bash
dotnet new serverless.AspNetCoreWebAPI --name MyFirstSAM
cd MyFirstSAM
```

![generated files](/assets/images/2021-05-01-1.png)

These are the generated files. It is almost exact the same as `webapi` template. It has three files and one rename.

- aws-lambda-tools-defaults.json: When use `dotnet lambda` command, if we don't give the specific options value, it will use the value in this files.
- LambdaEntryPoint.cs: The entry point for lambda.
- serverless.template: The AWS CloudFormation template to create resources.
- LocalEntryPrint.cs: It is the rename of Program.cs for we run the applications locally.

The good things of `serverless.AspNetCoreWebAPI` are

- It converts Lambda Event to ASP.NET Context at LambdaEntryPoint.cs implicitly. We can write the app as a normal APS.NET app and there is no additional staff to adopt. (we even can deploy the app outside of AWS SAM, like Azure)
- It can run locally. If you use other templates like `serverless.EmptyServerless`. The code can not run locally out of box.

Since it is a regular ASP.NET, we can add supporting MVC or Razor pages ourself. For example, change the services as the below code.

```cs
# Startup.cs
public void ConfigureServices(IServiceCollection services)
{
    services
        .AddRazorPages() // support Razor Pages
        .AddControllersWithViews(); // support MVC
}
```

### serverless.template

AWS create the type `AWS::Serverless::Function` for SAM. This type will convert to `AWS::Lambda::Function` and `AWS::ApiGatewayV2::Api` and other resources at runtime, you can read the official document to know more about [AWS::Serverless::Function](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html).

By default, the template includes an APIGateway resources by defining `Events`. Type `Api` is old version REST API and it generated a useless path `/Prod` for stage because it is real difficult to create stage in one SAM. So we can change to type `HttpAPi` and do some modify as the below.

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Transform: AWS::Serverless-2016-10-31
Resources:
  Function:
    Type: AWS::Serverless::Function
    Properties:
      Handler: MyFirstSAM::MyFirstSAM.LambdaEntryPoint::FunctionHandlerAsync
      Runtime: dotnetcore3.1
      MemorySize: 256
      Timeout: 30
      Policies:
        - AWSLambda_FullAccess
      Events:
        HttpApiEvent:
          Type: HttpApi
          Properties:
            Path: /{proxy+}
            Method: ANY
Outputs:
  ApiURL:
    Value:
      Fn::Sub: https://${ServerlessHttpApi}.execute-api.${AWS::Region}.amazonaws.com/
```

> The serverless.template supports json and yaml format. So I usually convert it from json to yaml for better to read and write. However, you can still use json format.

If you change to `HttpApi`, if also need to change the inherit type at LambdaEntryPoint.cs

```
- LambdaEntryPoint : Amazon.Lambda.AspNetCoreServer.APIGatewayProxyFunction
+ LambdaEntryPoint : Amazon.Lambda.AspNetCoreServer.APIGatewayHttpApiV2ProxyFunction
```

## Deployment

The lambda tools also includes the deploy command `dotnet lambda deploy-serverless <stack-name>`. This one command will build the code and zip files and push the zip to S3. Then it push the template to CloudFormation and CloudFormation will create the stack for us. Since we HttpApi doesn't support stage, we can create different stacks as stages. Like the below commands.

```bash
cd "src/MyFirstSAM"
dotnet lambda deploy-serverless MyFirstSAMProd
dotnet lambda deploy-serverless MyFirstSAMStaging
```

The output will show the url. You can test the app on SAM now.

## Set Environment Variables

You can also define how to set environment variables of the app(lambda). There are two ways one is via [AWS SSM](https://aws.amazon.com/systems-manager/) and another is via `--template-parameter` option when exec `deploy-serverless` commands.

For example, we can change serverless.template to support them.

```yaml
Parameters:
  MyTPEnv:
    Type: String
  MySSMEnv:
    Type: AWS::SSM::Parameter::Value<String>
    Default: "/path/to/param"
Resources:
  Function:
    Type: AWS::Serverless::Function
    Properties:
      Environment:
        Variables:
          MyEnv: !Ref MyTPEnv
          MySSMEnv: !Ref MySSMEnv
```

and pass the value via `--template-parameter` or `-tp`

```bash
dotnet lambda deploy-serverless $STACK -tp "MyTPEnv=$VALUE;"
```

## Conclusion
AWS SAM is a great cloud hosting solution for .NET developers. Cheap and easy to use. 