//@auth
//@req(nodeId, port)
var envName = '${env.envName}';
var count = Math.max(fixedCloudlets, flexibleCloudlets)*128*8/10;
var resp = jelastic.env.control.AddContainerEnvVars(envName, session, nodeId, '{\"MAX_MEMORY\": \"${count}M\"}', 8080);
if (resp.result != 0) return resp;

return {
    result: 0
}