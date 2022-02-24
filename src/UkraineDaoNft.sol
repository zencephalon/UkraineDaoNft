// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

import "./Base64.sol";

contract UkraineDaoNft is Ownable, ReentrancyGuard, ERC1155 {
    using SafeMath for uint256;

    // 0.1 ether
    uint256 private constant MINT_COST_WEI = 100000000000000000;
    string private constant FLAG_URI =
        "ipfs://QmSdQHYf8GYjBC3fdK11WU9mPVRBmDKCsGyq823xPwKdrh";

    constructor() Ownable() ERC1155("") {}

    function mint(uint256 _number) public payable nonReentrant {
        require(
            msg.value >= MINT_COST_WEI * _number,
            "Please supply 0.1 ether per flag"
        );

        _mint(msg.sender, 0, _number, "");
    }

    function withdraw() external onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = owner().call{value: amount}("");
        require(success, "Withdraw failed");
    }

    /// @notice returns the uri metadata. Used by marketplaces and wallets to show the NFT
    function uri(uint256 _nftId) public view override returns (string memory) {
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "',
                        '"UkraineDAO NFT",',
                        '", ',
                        '"description" : ',
                        '"Proceeds from this NFT went to support Ukraine war relief",',
                        '"image": "',
                        FLAG_URI,
                        '"'
                        "}"
                    )
                )
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", json));
    }
}
