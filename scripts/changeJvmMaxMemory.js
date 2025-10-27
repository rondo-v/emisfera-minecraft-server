//@auth
//@req(nodeId, port)
var envName = '${env.envName}';
var count = Math.max(fixedCloudlets, flexibleCloudlets)*128*8/10;
var envs = {"MAX_MEMORY":count};
var resp = jelastic.env.control.AddContainerEnvVars(envName, session, nodeId, envs);
if (resp.result != 0) return resp;

return {
    result: 0
}