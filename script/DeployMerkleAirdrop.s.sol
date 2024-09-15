// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


import { MerkleAirdrop, IERC20 } from "../src/MerkleAirdrop.sol";
import { Script } from "forge-std/Script.sol";
import { SlamToken } from "../src/SlamToken.sol";
import { console } from "forge-std/console.sol";

contract DeployMerkleAirdrop is Script {
      bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    // 4 users, 25 Bagel tokens each
    uint256 public AMOUNT_TO_TRANSFER = 100 ether;
    function run() external returns (MerkleAirdrop, SlamToken) {
        return deployMerkleAirdrop();
    }

    function deployMerkleAirdrop() public returns (MerkleAirdrop, SlamToken) {
        vm.startBroadcast();
        SlamToken slamToken = new SlamToken();
        MerkleAirdrop merkleAirdrop = new MerkleAirdrop(ROOT, IERC20(slamToken));
        // Send Slam tokens -> Merkle Air Drop Contract
        slamToken.mint(slamToken.owner(), AMOUNT_TO_TRANSFER);
        IERC20(slamToken).transfer(address(merkleAirdrop), AMOUNT_TO_TRANSFER);
        vm.stopBroadcast();
        return (merkleAirdrop, slamToken);
    }
}