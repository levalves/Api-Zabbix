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

#Hostname=$1
CreateHost()
{
    JSON='
    {
        "jsonrpc": "2.0",
        "method": "host.create",
	    "params": {
		    "host" : "APIServer",
		    "status": 1,
            "interfaces": [
                {
                    "type": 1,
                    "main": 1,
                    "useip": 1,
                    "ip": "192.168.2.38",
                    "dns": "",
                    "port": 10050
                }
            ],
            "groups": [
                {
                    "groupid": 2
                }
            ],
            "templates": [
                {
                    "templateid": 10001
                }
            ]
        },
        "auth": "5e7fc9679278d07c4251e89ec29bd4ff32e1e7eb32b5c3375a859f7211f81d17",
        "id": 1
    }
    '
    curl -s -X POST -H "$HEADER" -d "$JSON" "$URL"
    echo "Host Criado com sucesso !!!"
}

CreateHost
