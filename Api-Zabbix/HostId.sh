#!/bin/sh
#set -x
URL='http://localhost/zabbix/api_jsonrpc.php'
HEADER='Content-Type:application/json'

hosts()
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
    HostId=$(curl -s -X POST -H "$HEADER" -d "$JSON" "$URL" | cut -d '"' -f10)
}

hosts
echo "HostID: $HostId"
