$(() => {
    console.log('main.js loaded');

    var API_BASE_URL = "http://localhost:5050/";
    var socket = null;
    var connectionId = null;

    $("#disconnect").click((e) => {
        if (socket)
        {
            socket.close();
        }

        e.preventDefault();
        return false;
    });

    $("#join").click((e) => {
        if (connectionId)
        {
            $.ajax({
                type: "POST",
                url: API_BASE_URL + "api/v1/webpubsub/group",
                data: JSON.stringify({
                    ConnectionId: connectionId,
                    GroupName: 'entre_order_OR000044'
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                headers: {
                    "ContentType": "application/json"
                },
                success: function(data) {
                    // Handle the server's response
                    console.log(data);

                    if (socket)
                    {
                        socket.send(
                            JSON.stringify(
                            {
                                type: "joinGroup",
                                group: 'entre_order_OR000044'
                            }
                            )
                        )
                    }
                },
                error: function(error) {
                    // Handle errors
                    console.error(error);
                }
            });
        }

        // if (socket)
        // {
        //     socket.send(
        //         JSON.stringify(
        //         {
        //             type: "joinGroup",
        //             group: 'entre_order_OR000044'
        //         }
        //         )
        //     )
        // }

        e.preventDefault();
        return false;
    });

    getAzurePubSubUrl = () => {
        return new Promise((resolve, reject) => {
            $.get(API_BASE_URL + "api/v1/webpubsub/token")
                .done(data => resolve(data.responseBody.objectVal))
                .fail(error => reject(error));
        });
    };

    getAzurePubSubUrl().then((url) => {
        socket = new WebSocket(
            url,
            'json.webpubsub.azure.v1'
        )
        
        socket.onopen = function (e) {
            console.log("[open] Connection established")
        }

        socket.onclose = (event) =>{
            if (event.wasClean) {
                console.log(`[close] Connection closed cleanly, code=${event.code} reason=${event.reason}`)
            } else {
                // e.g. server process killed or network down
                // event.code is usually 1006 in this case
                console.log('[close] Connection died')
            }
        }
      
        socket.onerror = (error) => {
            console.log(`[error] ${error.message}`)
        }

        socket.onmessage = (event) => {
            // parse json
            let dataRet = JSON.parse(event.data)
            console.log(dataRet)

            if (dataRet.event == "connected")
            {
                connectionId = dataRet.connectionId;
            }
        }
    });
});
