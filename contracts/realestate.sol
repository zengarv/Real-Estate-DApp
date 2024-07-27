//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
//import "node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./nft.sol";
import "./usermanage.sol";

contract RealEstatePlatform is ERC721URIStorage, Ownable{

    uint256 private _propertyIds;   // Property ID counter

    struct Property{
        uint256 id;
        address owner;
        string description;
        string ipfsHash; // IPFS Hash for property media
        uint256 price;
        bool isListed;

    }

    mapping(uint256 => Property) public properties;

    event PropertyListed(uint256 indexed propertyId, address indexed owner, uint256 price);
    event DeListProperty(uint256 indexed propertyId, address indexed owner);
    event PropertyBought(uint256 indexed propertyId, address indexed buyer, uint256 price);
    event PaymentDeposited(uint256 indexed propertyId, address indexed buyer, uint256 amount);
    event PaymentWithdrawn(uint256 indexed propertyId, address indexed seller, uint256 amount);

    PropertyNFT private nftContract;
    UserManagement private userManagementContract;
    
    
    
     
    constructor(address _nftContract,address _userManagementContract) ERC721("RealEstatePlatform" , "REP") Ownable(msg.sender)
    {
        nftContract = PropertyNFT(_nftContract);
        userManagementContract = UserManagement(_userManagementContract);
    }

    
    
    function ListingProp(string memory description, string memory ipfsHash, uint price) public onlyOwner      //to put property on sale
    {
        require(userManagementContract.getUser(msg.sender).isVerified, "User not registered");

       _propertyIds++;
        uint256 newPropertyId = _propertyIds;

        properties[newPropertyId] = Property({
            id: newPropertyId,
            owner: msg.sender,
            description: description,
            ipfsHash: ipfsHash,
            price: price,
            isListed: true});

        nftContract.mintProperty(ipfsHash,newPropertyId);  // Mint NFT for property
        emit PropertyListed(newPropertyId, msg.sender, price);  //to display
    }

    function delistProp(uint256 propertyId) public            //to remove property from sale
    {
        Property storage property = properties[propertyId];
        require(property.owner == msg.sender, "Only the owner can delist the property");
        require(property.isListed, "Property is not listed");

        property.isListed = false;
        emit DeListProperty(propertyId, msg.sender);
    }

    function buyProp(uint256 propertyId) public payable {
        Property storage property = properties[propertyId];
        require(property.isListed, "Property is not listed for sale");
        require(msg.value >= property.price, "Insufficient payment");
        require(userManagementContract.getUser(msg.sender).isVerified, "User not registered");

        // Deposit payment to contract
        emit PaymentDeposited(propertyId, msg.sender, msg.value);

        address prevOwner=property.owner;

        property.owner=msg.sender;
        property.isListed=false;

        _transfer(prevOwner, msg.sender, propertyId);
        payable(prevOwner).transfer(msg.value);
        emit PropertyBought(propertyId, msg.sender, property.price); 
        emit PaymentWithdrawn(propertyId, prevOwner, msg.value);
                                              
    }

    function getProperties() public view returns (Property [] memory)
    {
        uint256 totalProperties = _propertyIds;
        Property[] memory listedProperties = new Property[](totalProperties);
        uint256 counter=0;
        for (uint256 i=1; i<=totalProperties ; i++)
        {
            if(properties[i].isListed)
            {
                listedProperties[counter] = properties[i];
                counter++;
            }
        }
        return listedProperties;
    }
    
}





