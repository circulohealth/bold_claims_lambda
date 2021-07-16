if [ -z "$S3_BUCKET" ]
then
    echo "Variable S3_BUCKET is empty; aborting"
    exit
else
    echo "Deploying s3_bucket called $S3_BUCKET"
fi

aws s3api create-bucket --bucket=$S3_BUCKET --region us-east-2 --create-bucket-configuration LocationConstraint=us-east-2
