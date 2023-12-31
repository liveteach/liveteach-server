import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });
const connections = new Map();
const teachers = new Map();

wss.on('connection', function connection(ws) {
    let msg = JSON.stringify({type:"sync", data: Date.now(), from: "server"})
        ws.send(msg)
  
    
    const interval = setInterval(function ping() {
      connections.forEach(function each(ws) {  
        let msg = JSON.stringify({type:"sync", data: Date.now(), from: "server"})
        ws.send(msg)
      });
    }, 3000);

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
                    case "display_image":
                    case "play_video":
                    case "pause_video":
                    case "resume_video":
                    case "set_video_volume":
                    case "play_model":
                    case "pause_model":
                    case "resume_model":
                    case "deactivate_screens":
                    case "deactivate_models":
                    case "content_unit_start":
                    case "content_unit_end":
                    case "content_unit_teacher_send":
                    case "share_classroom_config":
                        isValidWalletAndGuid(json)
                    break;
                    case "join_class":
                    case "exit_class":
                    case "content_unit_student_send":
                        broadcast(json.body.topic, JSON.stringify({type:json.body.message, data: json.body.payload, from: json.body.from}))
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
        clearInterval(interval);
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
            broadcast(json.body.topic, JSON.stringify({type:json.body.message, data: json.body.payload, from: json.body.from}))
        }
    })
}