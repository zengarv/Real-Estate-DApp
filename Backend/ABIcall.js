import axios from 'axios';

const mintProperty = async (tokenURI, royalty, account, privateKey) => {
    try {
        const response = await axios.post('http://localhost:3000/mintProperty', {
            tokenURI,
            royalty,
            account,
            privateKey
        });
        console.log(response.data);
    } catch (error) {
        console.error(error);
    }
};
