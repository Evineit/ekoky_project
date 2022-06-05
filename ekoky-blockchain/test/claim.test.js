const EkokyToken = artifacts.require("EkokyToken");
const EkokyNFT = artifacts.require("EkokyNFT");

contract('Claim Test', () => {

    it('Create NFT', async function () {
        // It should create
        const nftContract = await EkokyNFT.deployed();
        const tokenContract = await EkokyToken.deployed();

        const amount = 1;
        const name = "Ekoky de S.A. de C.V";
        const objetive = "Organic waste collection";
        const direction = "Durango, Durango. Mexico";
        const email = "alfredo.f.g.156@gmail.com";
        const phone = "6181087527";
        const nftId = 1;
        
        await tokenContract.approve(nftContract.address, amount);

        await nftContract.createJsonNFT(amount, name, objetive, direction, email, phone);
        assert.equal(nftContract.deployed);
    });
    
    it('Claim same NFT twice with one account', async function () {
        // It should be claim multiple times, by anyone
        const nftContract = await EkokyNFT.deployed();
        const tokenContract = await EkokyToken.deployed();

        const amount = 1;
        const name = "Naranjo";
        const objetive = "Organic waste collection";
        const direction = "Durango, Durango. Mexico";
        const email = "Naranjo@gmail.com";
        const phone = "0000000000";
        const nftId = 3;

        await tokenContract.approve(nftContract.address, amount);
        await nftContract.createJsonNFT(amount, name, objetive, direction, email, phone);

        await nftContract.claimJsonNFT(nftId);
        await nftContract.claimJsonNFT(nftId);
        assert.equal(nftContract.deployed);

    });
    
    it('Institute creates NFT, Business pay NFT', async function () {
        // Create from Institute, Claim from Business
        const nftContract = await EkokyNFT.deployed();
        const tokenContract = await EkokyToken.deployed();

        const wallet2 = "0x4E5Ae09c606d37e3Da15d8cb75b42fA1D943Da03"
        const wallet3 = "0x5f7CeBC7eC0c45d8aE1e56E9a40049B464C2dc50"

        const amount = 1;
        const name = "Charity";
        const objetive = "Donation";
        const direction = "Durango, Durango. Mexico";
        const email = "Charity@gmail.com";
        const phone = "0000000000";
        const nftId = 3;
        
        await nftContract.createJsonNFT(amount, name, objetive, direction, email, phone);





        
        await tokenContract.approve(nftContract.address, amount);
        await nftContract.claimJsonNFT(nftId);
        assert.equal(nftContract.deployed);
    });

    

});
