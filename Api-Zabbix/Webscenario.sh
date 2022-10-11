#!/bin/sh
#set -x
URL='http://localhost/zabbix/api_jsonrpc.php'
HEADER='Content-Type:application/json'

hosts()
{
    JSON='
    {
        "jsonrpc": "2.0",
        "method": "httptest.get",
        "params": {
            "output": "hostid",
            "selectSteps": [
                "hostid",
                "name",
                "url"
            ]
        },
        "auth": "5e7fc9679278d07c4251e89ec29bd4ff32e1e7eb32b5c3375a859f7211f81d17",
        "id": 0
    }
    '
    curl -s -X POST -H "$HEADER" -d "$JSON" "$URL" | python3 -mjson.tool
}
hosts
