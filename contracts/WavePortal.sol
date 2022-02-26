// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        uint256 timestamp;
        string message;
    }

    Wave[] waves;

    mapping(address => uint) public lastWaved;

    constructor() payable {
        console.log("Living like we're Renegades but aren't we?");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave (string memory _message) public {
        require(
            lastWaved[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30 secs"
        );

        lastWaved[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved with message: %s", msg.sender, _message);

        waves.push(Wave(msg.sender, block.timestamp, _message));

        
        seed = (block.timestamp + block.difficulty + seed) % 100;

        console.log("Random # generated: %d", seed);

        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;

            require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has."
            );

            (bool success, ) = (msg.sender).call{value:prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
        
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves () public view returns(uint256){
        console.log("We have %d total waves", totalWaves);
        return totalWaves;
    }
}