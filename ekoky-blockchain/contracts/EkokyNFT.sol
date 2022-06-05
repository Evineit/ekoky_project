//SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

pragma solidity ^0.8.10;

contract EkokyNFT is ERC721 {
    bytes32 public constant INSTITUTE_ROLE = keccak256("INSTITUTE_ROLE");
    bytes32 public constant BUSINESS_ROLE = keccak256("BUSINESS_ROLE");

    struct JsonNFT {
        uint256 amount;
        string name;
        string objective;
        string direction;
        string email;
        string phone;
    }

    IERC20 public token; 
    uint256 public nftCounter; // nftCounter is used to generate unique nftIDs

    mapping(uint256 => JsonNFT) public JsonNFTs; // mapping from nftIDs to JsonNFT-structs

    event CreateJsonNFT(address indexed sender, uint256 amount, string name, string objective, string direction, string email, string phone, uint256 nftId);
    event ClaimJsonNFT(address indexed sender, uint256 amount, string name, string objective, string direction, string email, string phone, uint256 claimTime, uint256 nftId);

    constructor(address _token)
    ERC721("Ekoky Json NFT", "JsonNFT") {
        token = IERC20(_token);
        nftCounter = 0;
    }

    receive() external payable {
        // prevent the native coin of a chain (ZENIQ coin) to be sent to this contract
        revert("Native deposit not supported");
    }

    function createJsonNFT(uint256 _amount, string memory _name, string memory _objective, string memory _direction, string memory _email, string memory _phone) external returns (bool) {
        require(_amount > 0, "Amount needs to be greater than 0");

        nftCounter++;
        JsonNFTs[nftCounter] = JsonNFT(_amount, _name, _objective, _direction, _email, _phone); // create NFT in the rewardsNFTs data structure
        _safeMint(msg.sender, nftCounter); // create NFT in data structures of the ERC721 super class

        emit CreateJsonNFT(msg.sender, _amount, _name, _objective, _direction, _email, _phone, nftCounter);
        return true;
    }

    function claimJsonNFT(uint256 nftId) public returns (bool) {
        // require(ownerOf(nftId) != msg.sender, "cannot claim an NFT that you do not own");

        JsonNFT storage nft = JsonNFTs[nftId];

        require(token.allowance(msg.sender, address(this)) >= nft.amount , "Set token allowance first");

        // Transfers tokens from your wallet to this contract
        bool successTx = token.transferFrom(msg.sender, address(this), nft.amount);
        require(successTx, "Transfer failed");

        emit ClaimJsonNFT(msg.sender, nft.amount, nft.name, nft.objective, nft.direction, nft.email, nft.phone, uint32(block.timestamp), nftId);
        return true;
    }

}
