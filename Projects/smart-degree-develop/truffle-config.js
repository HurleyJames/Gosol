require('babel-register')({
    ignore: /node_modules\/(?!openzeppelin-solidity)/
});

const HDWalletProvider = require('truffle-hdwallet-provider');
const mnemonic = "swallow still pepper train diesel mammal sad prevent detect hill put narrow"

require('babel-polyfill');
module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 7545,
            network_id: "*" // match any network
        },
        docker: {
            host: "192.168.99.100", // docker machine ip
            port: 8545,
            network_id: "*", // match any network
        },
        test: {
            host: "192.168.0.49", // ip for android test
            port: 8545,
            network_id: "*", // match any network
        },
        ropsten: {
            provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/ce8885f452054f45ae1ad34d03b01507`),
            network_id: 3, // Ropsten's id
            gas: 5500000, // Ropsten has a lower block limit than mainnet
            confirmations: 2, // # of confs to wait between deployments. (default: 0)
            timeoutBlocks: 200, // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true // Skip dry run before migrations? (default: false for public nets )
        },
    }
}