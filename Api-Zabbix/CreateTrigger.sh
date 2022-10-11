#!/bin/sh
#set -x
URL='http://localhost/zabbix/api_jsonrpc.php'
HEADER='Content-Type:application/json'

CreateTrigger()
{
        JSON='
        {
            "jsonrpc": "2.0",
            "method": "trigger.create",
            "params": [
                {
                    "description": "URL issue: http://microsoft.com return code is {ITEM.VALUE}",
                    "expression": "last(/HMC URL Monitor/web.test.rspcode[http://microsoft.com,http://microsoft.com])<>200",
                    "opdata": "{ITEM.LASTVALUE}",
                    "priority": "4"

                }
            ],
            "auth": "5e7fc9679278d07c4251e89ec29bd4ff32e1e7eb32b5c3375a859f7211f81d17",
            "id": 1
        }
        '
        curl -s -X POST -H "$HEADER" -d "$JSON" "$URL" | python3 -mjson.tool
}
CreateTrigger
