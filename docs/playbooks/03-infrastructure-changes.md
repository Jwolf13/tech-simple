# Infrastructure Changes Playbook

## When to Use
- Adding new AWS resources
- Changing CloudFront configuration
- Modifying S3 bucket settings
- Updating security policies

## Terraform Workflow

### Step 1: Plan Changes
cd ~/tech-helper-business/terraform

Make changes to main.tf
nano main.tf
code . 

Preview changes
terraform plan -out=tfplan



### Step 2: Review Plan
- Verify resources being added/changed/destroyed
- Check for unintended changes
- Document expected impact

### Step 3: Apply Changes
Apply planned changes
terraform apply tfplan

Save outputs
terraform output > outputs.txt



### Step 4: Verify Infrastructure
Check all resources created successfully
terraform state list

Verify specific resources
aws s3 ls | grep tech-simple
aws cloudfront list-distributions



### Step 5: Document Changes
Update architecture docs
nano ~/tech-helper-business/docs/architecture/ARCHITECTURE.md
code . ARCHITECTURE.md

Commit to Git
git add terraform/
git commit -m "Infrastructure: [description]"
git push



## Infrastructure Testing Checklist
- [ ] Website still accessible
- [ ] HTTPS working correctly
- [ ] All links functional
- [ ] CloudFront caching properly
- [ ] S3 bucket permissions correct
- [ ] No new AWS cost spikes

## Common Infrastructure Tasks

### Add New Domain
1. Update CloudFront alternate domain names
2. Request ACM certificate
3. Add DNS records
4. Update Terraform configuration

### Scale for Traffic
1. Review CloudFront price class
2. Enable CloudFront logging
3. Set up CloudWatch alarms
4. Consider S3 versioning

### Disaster Recovery
1. Enable S3 versioning
2. Set up cross-region replication
3. Document recovery procedures
4. Test recovery quarterly