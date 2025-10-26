//@auth
//@req(nodeId, port)

import com.hivext.api.development.Scripting;

var envName = '${env.envName}';

var resp = jelastic.env.control.AddEndpoint(envName, session, nodeId, port, "TCP", "Minecraft Server");
if (resp.result != 0) return resp;

var url = "${env.domain}:" + resp.object.publicPort;

var scripting =  hivext.local.exp.wrapRequest(new Scripting({
    serverUrl : "http://" + window.location.host.replace("app", "appstore") + "/"
}));

return {
    result: 0,
    onAfterReturn : {
        sendEmail : {
            url : url
        }
    }
}
