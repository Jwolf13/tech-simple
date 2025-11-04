# Access Management & IAM Security

## IAM User Management

### Review IAM Users Quarterly
List all IAM users
aws iam list-users --output table

Check user access keys age
aws iam list-access-keys --user-name terraform-user

Rotate access keys if >90 days old


### Rotate Access Keys (Every 90 Days)
1. Create new access key
aws iam create-access-key --user-name terraform-user

2. Update local AWS credentials
aws configure

3. Test new credentials
aws sts get-caller-identity

4. Delete old access key
aws iam delete-access-key --user-name terraform-user --access-key-id OLD_KEY_ID



### Review IAM Permissions
List attached policies
aws iam list-attached-user-policies --user-name terraform-user

Review policy details
aws iam get-policy-version
--policy-arn arn:aws:iam::aws:policy/AdministratorAccess
--version-id v1



## Principle of Least Privilege

### Current Permissions (Too Broad)
- terraform-user: AdministratorAccess 

### Recommended: Custom Policy
{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"s3:",
"cloudfront:",
"iam:GetUser",
"sts:GetCallerIdentity"
],
"Resource": "*"
}
]
}



### Apply Least Privilege Policy
Create custom policy
aws iam create-policy
--policy-name TechSimpleDeployPolicy
--policy-document file://policy.json

Detach admin access
aws iam detach-user-policy
--user-name terraform-user
--policy-arn arn:aws:iam::aws:policy/AdministratorAccess

Attach custom policy
aws iam attach-user-policy
--user-name terraform-user
--policy-arn arn:aws:iam::ACCOUNT_ID:policy/TechSimpleDeployPolicy



## MFA Enforcement
Enable MFA for root account (AWS Console)
1. Go to IAM → My Security Credentials
2. Enable MFA
3. Scan QR code with authenticator app


## Security Monitoring
- Review IAM credential report monthly
- Enable CloudTrail for API logging
- Set up CloudWatch alarms for root login
- Review AWS Access Advisor quarterly