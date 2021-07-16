if [ -z "$2" ]
then
    ZIP_VERSION="v1.0.0"
else
    ZIP_VERSION=$2
fi

aws s3 cp $1.zip s3://$S3_BUCKET/$ZIP_VERSION/$1.zip