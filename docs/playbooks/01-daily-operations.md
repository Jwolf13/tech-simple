Test website accessibility
curl -I https://d2gtcrpaoxe8s1.cloudfront.net

Expected: HTTP/2 200
If not 200, escalate to incident runbook


### 2. Check AWS Costs
View current month costs
aws ce get-cost-and-usage
--time-period Start=$(date +%Y-%m-01),End=$(date +%Y-%m-%d)
--granularity MONTHLY
--metrics "UnblendedCost"

Alert if > $10/month


### 3. Review S3 Bucket Status
List files in production bucket
aws s3 ls s3://tech-simple-website-84d8430bbbdc5b3b/

Should show:
index.html
style.css


### 4. Check CloudFront Distribution
Get distribution status
aws cloudfront get-distribution --id E29S00CKVCQ2LL
--query 'Distribution.Status' --output text

Expected: Deployed


### 5. Verify Terraform State
cd ~/tech-helper-business/terraform
terraform plan

Expected: No changes. Infrastructure is up-to-date.


## Metrics to Track Daily
- Site uptime: Target 99.9%
- Page load time: Target < 2s
- Error rate: Target < 0.1%
- AWS costs: Target < $10/month

## When to Escalate
- Site returns 5xx errors
- CloudFront distribution shows "InProgress" for >30 minutes
- Terraform shows unexpected changes
- AWS costs spike >50%