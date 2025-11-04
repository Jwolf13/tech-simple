
# Security Compliance & Audit Procedures

## Monthly Security Audit Checklist

### IAM Security
- [ ] Review all IAM users (no unused accounts)
- [ ] Verify MFA enabled on all users
- [ ] Check access keys age (<90 days)
- [ ] Review attached policies (least privilege)
- [ ] Generate IAM credential report

### Infrastructure Security
- [ ] S3 bucket public access settings correct
- [ ] CloudFront using HTTPS only
- [ ] No security groups with 0.0.0.0/0 access
- [ ] CloudTrail logging enabled
- [ ] AWS Config recording enabled

### Application Security
- [ ] Website served over HTTPS
- [ ] No sensitive data in Git repo
- [ ] Terraform state file secured
- [ ] Secrets not hardcoded
- [ ] Dependencies up to date

## Audit Commands

### Generate IAM Credential Report
Generate report
aws iam generate-credential-report

Wait 30 seconds
sleep 30

Download report
aws iam get-credential-report --output text
--query Content | base64 -d > iam-report.csv

Review
cat iam-report.csv


### Check S3 Bucket Security
Check public access blocks
aws s3api get-public-access-block
--bucket tech-simple-website-84d8430bbbdc5b3b

Check bucket policy
aws s3api get-bucket-policy
--bucket tech-simple-website-84d8430bbbdc5b3b

Check bucket encryption
aws s3api get-bucket-encryption
--bucket tech-simple-website-84d8430bbbdc5b3b


### Review CloudFront Security
Get distribution config
aws cloudfront get-distribution-config
--id E29S00CKVCQ2LL > cloudfront-config.json

Verify HTTPS redirect enabled
grep -A 5 "ViewerProtocolPolicy" cloudfront-config.json

Should show: "redirect-to-https"
Check TLS versions
grep -A 3 "MinimumProtocolVersion" cloudfront-config.json

Should be: TLSv1.2 or higher

### Scan for Sensitive Data
Check for exposed secrets
cd ~/tech-helper-business
grep -r "password|secret|key" --exclude-dir=".git"

Scan Terraform state for sensitive values
cd terraform
grep -i "password|secret" terraform.tfstate


## Compliance Standards

### CIS AWS Foundations Benchmark
- Enable MFA for root account ✅
- Ensure IAM password policy compliant
- Enable CloudTrail in all regions
- Enable S3 bucket logging
- Encrypt data at rest

### Best Practices
- Principle of least privilege for IAM
- Regular credential rotation (90 days)
- Enable multi-factor authentication
- Use encrypted connections (HTTPS/TLS)
- Regular security assessments
EOF
