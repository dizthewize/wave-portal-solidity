// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract FistBumpPortal {
    uint256 totalBumps;

    /*
    * We will be using this below to help generate a random number
    */
    uint256 private seed;

    event NewBump(address indexed from, uint256 timestamp, string message);

    /*
     * I created a struct here named Wave.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
     */
    struct Bump {
        address fistBumper; // The address of the user who fist bumped.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user fist bumped.
    }

    /*
     * I declare a variable bumps that lets me store an array of structs.
     * This is what lets me hold all the bumps anyone ever sends to me!
     */
    Bump[] bumps;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastFistBumpedAt;

    constructor() payable {
      console.log("We have been constructed!");
        /*
        * Set the initial seed
        */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function bump(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastFistBumpedAt[msg.sender] + 30 seconds < block.timestamp,
            "Must wait 30 seconds before waving again."
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastFistBumpedAt[msg.sender] = block.timestamp;

        totalBumps += 1;
        console.log("%s has fist bumped!", msg.sender);

        /*
         * This is where I actually store the wave data in the array.
         */
        bumps.push(Bump(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        if (seed <= 50) {
          console.log("%s won!", msg.sender);

          uint256 prizeAmount = 0.0001 ether;
          require(
              prizeAmount <= address(this).balance,
              "Trying to withdraw more money than the contract has."
          );
          (bool success, ) = (msg.sender).call{value: prizeAmount}("");
          require(success, "Failed to withdraw money from contract.");
        }

        emit NewBump(msg.sender, block.timestamp, _message);
    }

    /*
     * I added a function getAllFistBumps which will return the struct array, waves, to us.
     * This will make it easy to retrieve the fist bumps from our website!
     */
    function getAllFistBumps() public view returns (Bump[] memory) {
        return bumps;
    }

    function getTotalBumps() public view returns (uint256) {
        console.log("We have %d total fist bumps!", totalBumps);
        return totalBumps;
    }
}
