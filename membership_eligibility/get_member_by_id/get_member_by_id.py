from __future__ import print_function

import boto3
import json
import requests

NEPTUNE_SPARQL_URL = 'https://database-1-instance-1.c54zsiqinnhv.us-east-2.neptune.amazonaws.com:8182/sparql'

def handler(event, context):
    '''Provide an event that contains the following keys:

    - member_id: id of member to qery
    '''
    print("Received event: " + json.dumps(event, indent=2))
    event_body = json.loads(event['body'])
    member_id = event_body['member_id']

    # select all query for test purposes
    query_string = """
    PREFIX mock:  <http://circulo_mock_data/2021/06/16/#>

    SELECT ?s
    WHERE {
        ?s mock:member_id mock:%s
    }
    """ % member_id

    # Send POST request to Neptune with data 'query=<query string>'
    headers = {
        'Content-Type': 'application/octet-stream',
    }
    req_params = {
        'query': query_string
    }
    r = requests.post(NEPTUNE_SPARQL_URL, params=req_params, headers=headers)
    print("Neptune Response: " + r.text)

    response_body = json.loads(r.text)
    members_count = len(response_body['results']['bindings'])

    body = {
        "is_eligible": (members_count >= 1)
    }
    body = json.dumps(body)

    return_obj = {
        "isBase64Encoded": False,
        "statusCode": 200,
        "body": body,
        "headers": {
            "content-type": "application/json"
        }
    }

    return return_obj
