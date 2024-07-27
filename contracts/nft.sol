//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract PropertyNFT is ERC721URIStorage, Ownable {
    uint256 public tokenCount;
    mapping(uint256 => uint256) public royalties;

    event PropertyTokenized(uint256 tokenId, address owner, uint256 royalty);

    constructor() ERC721("PropertyNFT", "PNFT") Ownable(msg.sender) {}

    function mintProperty(string memory tokenURI, uint256 royalty) public onlyOwner {
        tokenCount++;
        _mint(msg.sender, tokenCount);
        _setTokenURI(tokenCount, tokenURI);
        royalties[tokenCount] = royalty;
        emit PropertyTokenized(tokenCount, msg.sender, royalty);
    }

    function transferProperty(address to, uint256 tokenId) public {
        safeTransferFrom(msg.sender, to, tokenId);
        uint256 royalty = royalties[tokenId];
        payable(ownerOf(tokenId)).transfer(royalty);
    }

    /*function _transfer(address from, address to, uint256 tokenId) override internal {
        super._transfer(from, to, tokenId);
        uint256 royalty = royalties[tokenId];
        payable(from).transfer(royalty);
    }*/
}
