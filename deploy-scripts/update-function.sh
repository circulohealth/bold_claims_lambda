go get
GOOS=linux go build $1.go
zip $1.zip $1

aws lambda update-function-code --function-name $1 --zip-file fileb://$1.zip
