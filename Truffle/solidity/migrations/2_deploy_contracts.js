var TransportTickets = artifacts.require("TransportTickets");
var Verify = artifacts.require("Verify");
var Greeter = artifacts.require("Greeter");

module.exports = function(deployer) {
    deployer.deploy(TransportTickets);
    deployer.deploy(Verify);
    deployer.deploy(Greeter);
}