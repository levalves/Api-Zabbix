#!/bin/sh
#set -x
URL='http://localhost/zabbix/api_jsonrpc.php'
HEADER='Content-Type:application/json'

USER='"apiuser"'
PASS='"dqm50vnc"'

autenticacao()
{
    JSON='
    {
	    "jsonrpc": "2.0",
	    "method": "user.login",
	    "params": {
		    "user": '$USER',
		    "password": '$PASS'
	    },
	    "id": 1
    }
    '
    curl -s -X POST -H "$HEADER" -d "$JSON" "$URL" | cut -d '"' -f8
		#curl -s -X POST -H "$HEADER" -d "$JSON" "$URL"
}
TOKEN=$(autenticacao)
echo "Token obtido: " $TOKEN

versao_api()
{
    JSON='
    {
        "jsonrpc": "2.0",
        "method": "apiinfo.version",
        "params": [],
        "id": 0
    }
    '
    VERSAO=$(curl -s -X POST -H "$HEADER" -d "$JSON" "$URL" | cut -d '"' -f8)
    #curl -s -X POST -H "$HEADER" -d "$JSON" "$URL"
    echo "Versao da API:" $VERSAO
}

versao_api
