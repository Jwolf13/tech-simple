
# Runbook: Site Down / Outage

## Symptoms
- Website returns 5xx errors
- Site unreachable
- Timeout errors

## Diagnosis Steps

### 1. Confirm Outage
Test from multiple locations
curl -I https://d2gtcrpaoxe8s1.cloudfront.net
wget --spider https://d2gtcrpaoxe8s1.cloudfront.net

Check from external service
https://downforeveryoneorjustme.com/d2gtcrpaoxe8s1.cloudfront.net


### 2. Check CloudFront Status
Get distribution status
aws cloudfront get-distribution --id E29S00CKVCQ2LL
--query 'Distribution.Status' --output text

Expected: Deployed
If InProgress: Wait for deployment to complete


### 3. Check S3 Bucket
Verify files exist
aws s3 ls s3://tech-simple-website-84d8430bbbdc5b3b/

Test direct S3 website endpoint
curl -I http://tech-simple-website-84d8430bbbdc5b3b.s3-website-us-east-1.amazonaws.com



### 4. Check CloudFront-S3 Connection
Verify origin settings
aws cloudfront get-distribution-config --id E29S00CKVCQ2LL
--query 'DistributionConfig.Origins.Items.DomainName'

Should match S3 website endpoint


## Resolution Procedures

### If S3 Bucket Empty
Restore from backup
BACKUP_DIR=$(ls -t ~/tech-helper-business/backups/ | head -1)
aws s3 sync ~/tech-helper-business/backups/$BACKUP_DIR/
s3://tech-simple-website-84d8430bbbdc5b3b/ --delete



### If CloudFront Distribution Error
Update distribution to force refresh
aws cloudfront create-invalidation
--distribution-id E29S00CKVCQ2LL --paths "/*"


### If Complete Failure
Rebuild entire infrastructure
cd ~/tech-helper-business/terraform
terraform destroy -auto-approve
terraform apply -auto-approve

Redeploy website
cd ../website
aws s3 sync . s3://tech-simple-website-84d8430bbbdc5b3b/ --delete



## Communication Template
INCIDENT: Tech Simple Website Outage

Time Detected: [TIME]
Impact: Website unavailable
Cause: [ROOT CAUSE]
Resolution: [ACTIONS TAKEN]
Time Resolved: [TIME]
Total Downtime: [DURATION]

Next Steps:

Post-mortem scheduled

Preventive measures implemented



## Post-Incident Review
1. Document root cause
2. Update runbook with lessons learned
3. Implement preventive measures
4. Test recovery procedures