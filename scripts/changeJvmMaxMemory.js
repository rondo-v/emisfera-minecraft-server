//@auth
//@req(nodeId, port)

import com.hivext.api.development.Scripting;

var envName = '${env.envName}';
var count = Math.max(fixedCloudlets, flexibleCloudlets)*128*8/10;
var resp = jelastic.env.control.AssContainerEnvVars(envName, session, nodeId, '{\"MAX_MEMORY\": \"1024M\"}');
if (resp.result != 0) return resp;

return {
    result: 0
}