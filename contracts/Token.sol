// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFT_token is ERC721Enumerable, Ownable{
    using Strings for uint256;
    
    
    //ERC721 constructor
    constructor(
        string memory _name,
        string memory _symbol
        )ERC721(_name, _symbol) {
        }
    
    //Basic Variables
    
    string public baseURI ="";                      //url of nfts
    string public baseExtension = ".json";      //extension of base files
    uint256 public maxSupply = 10000;           //max number of nft that can be minted
    uint256 public maxMintAmount = 20;          //max number of nft that can be minted in one go
    bool public paused = false;                 //paused change the
                 
        
    // To change url of nfts
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
            baseURI = _newBaseURI;
        }
    
        
    // To change max mint amount of nfts
    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
             maxMintAmount = _newmaxMintAmount;
        }
        
    // To change state of process of nfts
    function pause(bool _state) public onlyOwner {
            paused = _state;
        }

       
     // To change the max amount of token owner can hold 
    function setMaxSupply(uint256 _newmaxSupply) public onlyOwner {
            maxSupply=_newmaxSupply;
        }
        
    //Mint nfts to owner
    function mint(address _to,uint256 _mintAmount) public payable onlyOwner{
        
            uint supply = totalSupply();                        //Extract total number of nft for an address
            require(!paused);                                   //make sure contract is not paused
            require(_mintAmount > 0);                           //make sure mint amount is >0
            require(_mintAmount <= maxMintAmount);              //make sure mint amount do not exceed max mint amount at a time
            require(supply + _mintAmount <= maxSupply);         //total number of nft must be less than total supply
            
            
            for (uint256 i=1; i<= _mintAmount; i++) {
                _safeMint(_to,supply+i);
            }
            
        }
        
    function walletOfOwner(address _owner) public view returns(uint256[] memory) {
            uint256 ownerTokenCount = balanceOf(_owner);
            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
            for(uint256 i=0; i<ownerTokenCount; i++) {
                tokenIds[i] = tokenOfOwnerByIndex(_owner,i);
            }
            return tokenIds;
        }
        
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
            require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
            
            string memory currentBaseURI = _baseURI();
            return bytes(currentBaseURI).length > 0 
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(),baseExtension)) 
            : "";
        }   
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}