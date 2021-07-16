package main

import (
	"github.com/aws/aws-lambda-go/lambda"
)

func handleRequest() (string, error) {
	// Hardcoding a json response for simple verification of api integration
	// Will be handled in depth in further packages
	response := `{"isBase64Encoded":"false","statusCode":"200","body":"Hello from Lambda!","headers":{"content-type":"application/json"}}`

	return response, nil
}

func main() {
	lambda.Start(handleRequest)
}
