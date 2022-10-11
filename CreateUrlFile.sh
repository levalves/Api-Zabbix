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

ListTemplates()
{
    JSON='
    {
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": [
                "templateid"
            ],
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
    TemplateId=$(curl -s -X POST -H "$HEADER" -d "$JSON" "$APIURL" | cut -d '"' -f10)
}

CreateUrl()
{
    for URL in `cat $CCC.url`
    do
        echo "URL: '$URL'"
        SHORT_URL=`echo $URL | cut -c 1-64`
        URLZBX=`echo $URL | cut -d";" -f1`
        HOST=`echo $URL | cut -d";" -f2`
        JSON='
        {
            "jsonrpc": "2.0",
            "method": "httptest.create",
            "params": {
                "name": "'$SHORT_URL'",
                "hostid": "'$HostId'",
                "steps": [
                    {
                        "name": "'$SHORT_URL'",
                        "url": "'$URLZBX'",
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
    done 
}

CreateTrigger()
{
    for URL in `cat $CCC.url`
        do
            echo "URL: '$URL'"
            SHORT_URL=`echo $URL | cut -c 1-64`
            URLZBX=`echo $URL | cut -d";" -f1`
            HOST=`echo $URL | cut -d";" -f2`
                JSON='
                {
                    "jsonrpc": "2.0",
                    "method": "trigger.create",
                    "params": [
                        {
                            "description": "URL issue: '$SHORT_URL' return code is {ITEM.VALUE}",
                            "expression": "last(/'$CCC' URL Monitor/web.test.rspcode['$SHORT_URL','$SHORT_URL'])<>200",
                            "opdata": "{ITEM.LASTVALUE}",
                            "priority": "4",
                            "tags": [
                                {
                                    "tag": "ResourceId",
                                    "value": "'$HOST'"
                                }
                            ]
                        }
                    ],
                    "auth": "5e7fc9679278d07c4251e89ec29bd4ff32e1e7eb32b5c3375a859f7211f81d17",
                    "id": 1
                }
                '
        curl -s -X POST -H "$HEADER" -d "$JSON" "$APIURL" | python3 -mjson.tool
        echo "Trigger Criado com sucesso !!!"
    done 
}

Hosts
ListTemplates
CreateUrl
CreateTrigger
