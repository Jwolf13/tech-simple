#!/bin/bash

# Tech Simple Health Check Script
# Run daily via cron: 0 9 * * * ~/tech-helper-business/scripts/healthcheck.sh

echo "=== Tech Simple Health Check ==="
echo "Date: $(date)"
echo ""

# Test website
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://d2gtcrpaoxe8s1.cloudfront.net)
if [ "$HTTP_CODE" == "200" ]; then
    echo "✅ Website: OK (HTTP $HTTP_CODE)"
else
    echo "❌ Website: FAILED (HTTP $HTTP_CODE)"
    # Send alert (configure email/Slack)
fi

# Check CloudFront
CF_STATUS=$(aws cloudfront get-distribution --id E29SO0CKVCQ2LL --query 'Distribution.Status' --output text)
if [ "$CF_STATUS" == "Deployed" ]; then
    echo "✅ CloudFront: $CF_STATUS"
else
    echo "⚠️  CloudFront: $CF_STATUS"
fi

# Check S3 bucket
S3_FILES=$(aws s3 ls s3://tech-simple-website-84d8430bbbdc5b3b/ | wc -l)
if [ "$S3_FILES" -ge 2 ]; then
    echo "✅ S3 Bucket: $S3_FILES files"
else
    echo "❌ S3 Bucket: Only $S3_FILES files (expected >=2)"
fi

echo ""
echo "=== Health Check Complete ==="
