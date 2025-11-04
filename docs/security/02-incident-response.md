# Security Incident Response Playbook

## Incident Types

### 1. Unauthorized Access Detected
**Indicators:**
- Unfamiliar IAM users
- Unexpected AWS resources
- CloudTrail shows unknown IP addresses

**Immediate Actions:**
1. List all IAM users
aws iam list-users

2. Check for unauthorized resources
aws resourcegroupstaggingapi get-resources --output table

3. Disable compromised user
aws iam update-user --user-name COMPROMISED_USER --no-password-reset-required

4. Delete unauthorized access keys
aws iam list-access-keys --user-name COMPROMISED_USER
aws iam delete-access-key --user-name USER --access-key-id KEY_ID


### 2. Website Defacement
**Indicators:**
- Website content changed
- Unexpected files in S3

**Immediate Actions:**
1. Restore from backup immediately
BACKUP_DIR=$(ls -t ~/tech-helper-business/backups/ | head -1)
aws s3 sync ~/tech-helper-business/backups/$BACKUP_DIR/
s3://tech-simple-website-84d8430bbbdc5b3b/ --delete

2. Invalidate CloudFront
aws cloudfront create-invalidation
--distribution-id E29S00CKVCQ2LL --paths "/*"

3. Review S3 access logs
aws s3api get-bucket-logging --bucket tech-simple-website-84d8430bbbdc5b3b


### 3. DDoS Attack
**Indicators:**
- Sudden traffic spike
- High CloudFront costs
- Site slow/unresponsive

**Immediate Actions:**
1. Enable AWS Shield Standard (free, automatic)
Already enabled by default
2. Review CloudFront metrics
aws cloudwatch get-metric-statistics
--namespace AWS/CloudFront
--metric-name Requests
--dimensions Name=DistributionId,Value=E29S00CKVCQ2LL
--start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S)
--end-time $(date -u +%Y-%m-%dT%H:%M:%S)
--period 300
--statistics Sum

3. Contact AWS Support if sustained attack

### 4. Cost Spike Alert
**Indicators:**
- AWS bill >$50 unexpectedly
- Unusual resource usage

**Investigation:**
1. Check current costs
aws ce get-cost-and-usage
--time-period Start=$(date -d '7 days ago' +%Y-%m-%d),End=$(date +%Y-%m-%d)
--granularity DAILY
--metrics "UnblendedCost"
--group-by Type=SERVICE

2. List all resources
aws resourcegroupstaggingapi get-resources

3. Terminate unauthorized resources
aws ec2 describe-instances
aws rds describe-db-instances


## Post-Incident Actions
1. Document timeline in incident log
2. Update security procedures
3. Review IAM policies
4. Rotate all credentials
5. Schedule security audit

