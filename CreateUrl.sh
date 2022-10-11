#!/bin/sh
#set -x
APIURL='http://localhost/zabbix/api_jsonrpc.php'
HEADER='Content-Type:application/json'

Hosts()
{
    echo -n "Digite CCC: ";
    read CCC

    JSON='
    {
      "jsonrpc": "2.0",
      "method": "host.get",
      "params": {
        "output": [
          "hostid"
        ],
        "search": {
            "host": "*'$CCC' URL Monitor*"
        },
        "searchWildcardsEnabled": true,
        "searchByAny": true,
        "sortfield": "host",
        "sortorder": "DESC"
      },
      "auth": "5e7fc9679278d07c4251e89ec29bd4ff32e1e7eb32b5c3375a859f7211f81d17",
      "id": 1
    }
    '
    HostId=$(curl -s -X POST -H "$HEADER" -d "$JSON" "$APIURL" | cut -d '"' -f10)
}

CreateUrl()
{
    echo -n "Digite a URL: ";
    read URL
    echo "URL: $URL"
    JSON='
    {
        "jsonrpc": "2.0",
        "method": "httptest.create",
        "params": {
            "name": "'$URL'",
            "hostid": "'$HostId'",
            "steps": [
                {
                    "name": "'$URL'",
                    "url": "'$URL'",
                    "status_codes": "200",
                    "no": 1
                }
            ]
        },
        "auth": "5e7fc9679278d07c4251e89ec29bd4ff32e1e7eb32b5c3375a859f7211f81d17",
        "id": 1
    }
    '
    curl -s -X POST -H "$HEADER" -d "$JSON" "$APIURL" | python3 -m json.tool
    echo "URL Criado com sucesso !!!"
}

Hosts
echo "HostID: $HostId"
CreateUrl
