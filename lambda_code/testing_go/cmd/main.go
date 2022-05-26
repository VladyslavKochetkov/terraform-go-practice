package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
)

type LambdaEvent struct {
	Key1 string `json:"key1"`
}

func HandleRequest(ctx context.Context, event LambdaEvent) (string, error) {
	lc, _ := lambdacontext.FromContext(ctx)
	fmt.Printf("Request Id: %s\n", lc.AwsRequestID)
	fmt.Printf("Event key1: %s\nEvent: %s\n", event.Key1, event)

	return "Ran Handle Request", nil
}

func main() {
	lambda.Start(HandleRequest)

}
