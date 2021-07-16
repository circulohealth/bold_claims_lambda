aws lambda invoke --function-name $1 --invocation-type RequestResponse $1-response.txt
cat $1-response.txt
