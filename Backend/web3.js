const Web3 = require('web3');

// Connect to Ethereum node (Infura or local node)
const web3 = new Web3(new Web3.providers.HttpProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID'));

// Load your smart contract's ABI and address
const PropertyNFTABI = require('./build/PropertyNFT.json').abi;
const propertyNFTAddress = 'YOUR_DEPLOYED_CONTRACT_ADDRESS';

const propertyNFTContract = new web3.eth.Contract(PropertyNFTABI, propertyNFTAddress);
