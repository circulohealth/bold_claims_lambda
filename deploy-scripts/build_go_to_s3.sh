if [ -z "$2" ]
then
    ZIP_VERSION="v$2"
else
    ZIP_VERSION=$2
fi

GOOS=linux go build $1.go
zip $1.zip $1
aws s3 cp $1.zip s3://$S3_BUCKET/v$ZIP_VERSION/$1.zip