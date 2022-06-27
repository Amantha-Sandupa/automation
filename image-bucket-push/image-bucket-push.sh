#!/bin/bash
SERVICE_ACCOUNT_NAME=cdn-bucket-push@pickme-production-210708.iam.gserviceaccount.com
KEY_FILE_PATH=/var/lib/jenkins/service-accounts/cdn-upload/pickme-production-210708-8e5ace67b944.json 

#file upload to Jenkins workspace validation
echo "Uploading file to GCP Bucket"
pwd
cd images && ls -la
unzip files.zip
rm -rf files.zip
printf '%s\n' * > /var/lib/jenkins/workspace/automated-tasks/devops/Storage-Infrastructure/gcp-bucket-image-upload-prod/list.txt
cat /var/lib/jenkins/workspace/automated-tasks/devops/Storage-Infrastructure/gcp-bucket-image-upload-prod/list.txt

#gcloud authentication validation
gcloud auth activate-service-account ${SERVICE_ACCOUNT_NAME} --key-file=${KEY_FILE_PATH}
gcloud config list account

#bucket upload
gsutil cp -pr * gs://prod-cdn-pickme/${FILE_PATH}

#bucket object validation
while read n; do
  echo "To check $n: https://cdn.pickme.lk/${FILE_PATH}$n"
done </var/lib/jenkins/workspace/automated-tasks/devops/Storage-Infrastructure/gcp-bucket-image-upload-prod/list.txt

#local file cleanup
cd /var/lib/jenkins/workspace/automated-tasks/devops/Storage-Infrastructure/gcp-bucket-image-upload-prod && rm -rf images/
rm -rf /var/lib/jenkins/workspace/automated-tasks/devops/Storage-Infrastructure/gcp-bucket-image-upload-prod/list.txt
echo "File upload to bucket and local file cleanup successful"