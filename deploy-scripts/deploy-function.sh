GOOS=linux go build $1.go
zip $1.zip $1

aws lambda create-function \
--function-name $1 \
--zip-file fileb://$1.zip \
--handler $1 \
--runtime go1.x \
--role "arn:aws:iam::057366268768:role/lambda-basic-execution" \
--vpc-config "SubnetIds=subnet-7a92b036,subnet-91ae22fa,subnet-3531cb48,SecurityGroupIds=sg-e4f5d8ad"

