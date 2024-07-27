app.post('/mintProperty', async (req, res) => {
    const { tokenURI, royalty, account, privateKey } = req.body;

    const tx = {
        to: propertyNFTAddress,
        data: propertyNFTContract.methods.mintProperty(tokenURI, royalty).encodeABI(),
        gas: 2000000
    };

    const signedTx = await web3.eth.accounts.signTransaction(tx, privateKey);
    web3.eth.sendSignedTransaction(signedTx.rawTransaction)
        .on('receipt', receipt => {
            res.send(receipt);
        })
        .on('error', err => {
            res.status(500).send(err);
        });
});
app.post('/register', async (req, res) => {
    const { username, email } = req.body;

    const newUser = new User({ username, email });
    await newUser.save();

    res.send(newUser);
});

app.get('/properties', async (req, res) => {
    const properties = await Property.find({ isListed: true });
    res.send(properties);
});

app.post('/listProperty', async (req, res) => {
    const { id, owner, description, ipfsHash, price } = req.body;

    const newProperty = new Property({ id, owner, description, ipfsHash, price, isListed: true });
    await newProperty.save();

    res.send(newProperty);
});

app.post('/buyProperty', async (req, res) => {
    const { propertyId, buyer } = req.body;

    const property = await Property.findOne({ id: propertyId });
    if (property) {
        property.owner = buyer;
        property.isListed = false;
        await property.save();

        res.send(property);
    } else {
        res.status(404).send('Property not found');
    }
});
