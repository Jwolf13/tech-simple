# Deployment Playbook

## Pre-Deployment Checklist
- [ ] Changes tested locally
- [ ] Git commit created with descriptive message
- [ ] Backup of current production taken
- [ ] Change approved (if required)

## Standard Deployment Process

### Step 1: Backup Current Production
Create backup of current site
cd ~/tech-helper-business
mkdir -p backups/$(date +%Y%m%d-%H%M%S)
aws s3 sync s3://tech-simple-website-84d8430bbbdc5b3b/
backups/$(date +%Y%m%d-%H%M%S)/



### Step 2: Update Website Files
cd ~/tech-helper-business/website

Make your changes here
nano index.html
code .



### Step 3: Deploy to Production
Upload to S3
aws s3 sync . s3://tech-simple-website-84d8430bbbdc5b3b/ --delete

Invalidate CloudFront cache
cd ../terraform
aws cloudfront create-invalidation
--distribution-id $(terraform output -raw cloudfront_distribution_id)
--paths "/*"



### Step 4: Verify Deployment
Wait 30 seconds
sleep 30

Test site
curl -I https://d2gtcrpaoxe8s1.cloudfront.net

Visual check in browser
firefox https://d2gtcrpaoxe8s1.cloudfront.net



### Step 5: Post-Deployment
Commit changes to Git
git add .
git commit -m "Deploy: [description of changes]"
git push origin main

Document in deployment log
echo "$(date): Deployed [changes]" >> ~/tech-helper-business/deployment.log



## Rollback Procedure
If deployment fails:
Restore from backup
BACKUP_DIR=$(ls -t ~/tech-helper-business/backups/ | head -1)
aws s3 sync ~/tech-helper-business/backups/$BACKUP_DIR/
s3://tech-simple-website-84d8430bbbdc5b3b/ --delete

Invalidate cache
aws cloudfront create-invalidation
--distribution-id E29S00CKVCQ2LL
--paths "/*"



## Deployment Windows
- Preferred: Tuesday-Thursday, 10 AM - 2 PM EST
- Avoid: Fridays, weekends, holidays
- Emergency: Anytime with proper documentation