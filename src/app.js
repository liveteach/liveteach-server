import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });
const connections = new Map();
const teachers = new Map();

wss.on('connection', function connection(ws) {

   ws.on('message', function message(data) {

        let json = JSON.parse(data);

        switch(json.header.type.toLowerCase()){
            case "subscribe":
                const channel = json.body.topic;
                connections.set(channel,ws)

                //return a Auth guid for teachers
                if(json.body.topic === "teacher"){
                    let guid = getGuid()
                    broadcast(json.body.topic, JSON.stringify({type:"guid", data: guid}))
                } 
            break;
            case "unsubscribe":
                const remove = json.body.topic;
                connections.delete(remove)
            break;
            case "message":
                // check standard Commands if Teacher controlled check the wallet and guid
                switch (json.body.message) {
                    case "activate_class":
                    case "deactivate_class":
                    case "start_class":
                    case "end_class":
                    case "log":
                        isValidWalletAndGuid(json)
                    break;
                    case "join_class":
                    case "exit_class":
                        broadcast(json.body.topic, JSON.stringify({type:json.body.message, data: json.body.message, from: json.body.from}))
                    break;
                }
            break;
            case "register":
                teachers.set(json.body.wallet, json.body.guid)
            break
            default:
                ws.send("Unable to parse message");
            break;
        }

    });

    ws.on('close', () => {
        connections.delete(ws);
    });

});


function broadcast(channel, message) {
    connections.forEach((ws, key) => {
    if (key === channel) {
        ws.send(message);
    }
    });
}

function getGuid() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        const r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16)
    })
}

function isValidWalletAndGuid(json){
    teachers.forEach((guid, wallet) => {
        if(json.body.wallet === wallet && json.body.guid === guid){
            broadcast(json.body.topic, JSON.stringify({type:json.body.message, data: json.body.message, from: json.body.from}))
        }
    })
}