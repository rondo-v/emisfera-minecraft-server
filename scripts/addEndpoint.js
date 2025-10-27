//@auth
//@req(nodeId, port)
var envName = '${env.envName}';

var resp = jelastic.env.control.AddEndpoint(envName, session, nodeId, port, "TCP", "Minecraft Server");
if (resp.result != 0) return resp;

var url = "${env.domain}:" + resp.object.publicPort;

return {
    result: 0,
    onAfterReturn : {
        sendEmail : {
            url : url
        }
    }
}
