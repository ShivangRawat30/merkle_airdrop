// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {SlamToken} from "../src/SlamToken.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {DeployMerkleAirdrop} from "../script/DeployMerkleAirdrop.s.sol";

contract MerkelAirDropTest is Test {
    MerkleAirdrop public airdrop;
    SlamToken public token;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 public AMOUNT_TO_CLAIM = 25 ether;
    uint256 public AMOUNT_TO_SEND = 100 ether;
    bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [proofOne,proofTwo];

    address user;
    uint256 userPrivateKey;
    address gasPayer;


    function setUp() public {
        DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (airdrop, token) = deployer.deployMerkleAirdrop();
        (user, userPrivateKey) = makeAddrAndKey("user");
        gasPayer = makeAddr("gasPayer");


    }

    function signMessage(uint256 privKey, address account) public view returns(uint8 v, bytes32 r, bytes32 s) {
        bytes32 hashedMessage = airdrop.getMessageHash(account, AMOUNT_TO_CLAIM);
        (v,r,s) = vm.sign(privKey, hashedMessage);
    }

    function testUsersCanClaim() public {
        // console.log(user);
        uint256 startingBalance = token.balanceOf(user);

        // get the sigature
        vm.prank(user);
        (uint8 v, bytes32 r, bytes32 s) = signMessage(userPrivateKey, user);
        vm.stopPrank();

        vm.prank(gasPayer);
        airdrop.claim(user, AMOUNT_TO_CLAIM, PROOF, v, r, s);
        
        uint256 endingBalance = token.balanceOf(user);
        console.log("Ending Balance: ", endingBalance);
        assertEq(endingBalance - startingBalance, AMOUNT_TO_CLAIM);

    }
} 