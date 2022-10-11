#!/bin/sh
#set -x
APIURL='http://localhost/zabbix/api_jsonrpc.php'
HEADER='Content-Type:application/json'

ListTemplates()
{
    echo -n "Digite CCC: "
    read CCC
    JSON='
    {
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output":
                "extend",
            "search": {
                "host": "*'$CCC' Web Monitoring*"
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
        #HostId=$(curl -s -X POST -H "$HEADER" -d "$JSON" "$APIURL" | cut -d '"' -f10)
        curl -s -X POST -H "$HEADER" -d "$JSON" "$APIURL" | python3 -m json.tool
}
ListTemplates
#echo $HostId
