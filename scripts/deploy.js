// scripts/deploy.js

async function main() {
    // We get the contract to deploy
    const PropertyNFT = await ethers.getContractFactory("PropertyNFT");
    const propertyNFT = await PropertyNFT.deploy();
    await propertyNFT.deployed();
    console.log("PropertyNFT deployed to:", propertyNFT.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
