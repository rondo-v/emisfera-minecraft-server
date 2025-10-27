//@auth
//@req(nodeId, port)

import com.hivext.api.development.Scripting;

var envName = '${env.envName}';
var count = Math.max(fixedCloudlets, flexibleCloudlets)*128*8/10;
var resp = jelastic.env.control.SetContainerEnvVars(envName, session, nodeId, '{\"MAX_MEMORY\": \"${count}M\"}');
if (resp.result != 0) return resp;

return {
    result: 0
}