//SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

pragma solidity ^0.8.10;

// This contract creates "reward-NFTs" that hold a specified amount of token.
// Those reward-NFTs can be claimed to payout tokens to NFT-owners.
// You can think of reward-NFTs like a voucher or gift card.
contract EkokyNFT is ERC721 {
    mapping (address => uint) balances;

    struct JsonNFT {
        // this struct can be expanded for application-specific NFT functionalities
        uint256 amount;
        string name;
        string objective;
        string direction;
        string email;
        string phone;
    }

    IERC20 public token; // holds the contract-address of a deployed token (ZenconToken), to be used for rewards
    uint256 public nftCounter; // nftCounter is used to generate unique nftIDs

    mapping(uint256 => JsonNFT) public JsonNFTs; // mapping from nftIDs to JsonNFT-structs

    event CreateJsonNFT(address indexed sender, uint256 amount, string name, string objective, string direction, string email, string phone, uint256 nftId);
    event ClaimJsonNFT(address indexed sender, uint256 amount, string name, string objective, string direction, string email, string phone, uint256 claimTime, uint256 nftId);

    constructor(address _token)
    ERC721("Ekoky Json NFT", "JsonNFT") { // invoke constructor from super class
        // initialize global variables in constructor
        token = IERC20(_token);
        nftCounter = 0;
    }

    receive() external payable {
        // prevent the native coin of a chain (ZENIQ coin) to be sent to this contract
        revert("Native deposit not supported");
    }

    function createJsonNFT(uint256 _amount, string memory _name, string memory _objective, string memory _direction, string memory _email, string memory _phone) external returns (bool) {
        require(_amount > 0, "Amount needs to be greater than 0");

        // require(compareStrings(_name, ""), "Name must not be empty");
        // require(compareStrings(_direction, ""), "Direction must not be empty");
        // require(compareStrings(_email, ""), "Email must not be empty");
        // require(compareStrings(_phone, ""), "Phone must not be empty");

        // Check if this contract is allowed to transfer ERC20-tokens from your wallet.
        // An allowance can be granted by calling the approve-function of the ERC20-token.
        // For example, a frontend can connect to a wallet and call the approve-function right before calling this function.
        require(token.allowance(msg.sender, address(this)) >= _amount, "Set token allowance first");

        // Transfers tokens from your wallet to this contract
        bool successTx = token.transferFrom(msg.sender, address(this), _amount);
        require(successTx, "Transfer failed");

        nftCounter++;
        JsonNFTs[nftCounter] = JsonNFT(_amount, _name, _objective, _direction, _email, _phone); // create NFT in the rewardsNFTs data structure
        _safeMint(msg.sender, nftCounter); // create NFT in data structures of the ERC721 super class

        emit CreateJsonNFT(msg.sender, _amount, _name, _objective, _direction, _email, _phone, nftCounter);
        return true;
    }

    function claimJsonNFT(uint256 nftId) public returns (bool) {
        require(ownerOf(nftId) == msg.sender, "cannot claim an NFT that you do not own");

        JsonNFT storage nft = JsonNFTs[nftId];
        // require(nft.active, "cannot claim the same NFT twice");
        // nft.active = false; // prevent the same NFT from being claimed multiple times

        bool success = token.transfer(msg.sender, nft.amount);
        require(success == true, "Transfer failed");

        emit ClaimJsonNFT(msg.sender, nft.amount, nft.name, nft.objective, nft.direction, nft.email, nft.phone, uint32(block.timestamp), nftId);
        return true;
    }

    // Internal

    function getBalance(address addr) public view returns(uint) {
        return balances[addr];
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}
