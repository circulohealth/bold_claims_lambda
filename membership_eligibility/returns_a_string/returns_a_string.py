from __future__ import print_function

import boto3
import json

print('Loading function')


def handler(event, context):
    '''Provide an event that contains the following keys:
    '''
    print("Received event: " + json.dumps(event, indent=2))

    body = "This is a test string"
    return_obj = {
        "isBase64Encoded": False,
        "statusCode": 200,
        "body": body,
        "headers": {
            "content-type": "application/json"
        }
    }

    return return_obj
