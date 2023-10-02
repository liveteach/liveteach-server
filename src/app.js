import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });
const connections = new Map();

wss.on('connection', function connection(ws) {

   ws.on('message', function message(data) {

        let json = JSON.parse(data);

        switch(json.header.type.toLowerCase()){
            case "subscribe":
                const channel = json.body.topic;
                connections.set(channel,ws)
            break;
            case "unsubscribe":
                const remove = json.body.topic;
                connections.delete(remove)
            break;
            case "message":
                broadcast(json.body.topic, JSON.stringify({typ:"message", data: json.body.message}))
            break;
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