// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Staker {
  ExampleExternalContract public exampleExternalContract;

  event Stake(address sender, uint amount); 

  mapping ( address => uint256 ) public balances;

  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 30 seconds;
  bool openForWithdraw = false;

  constructor(address exampleExternalContractAddress) {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  modifier passedDeadline(bool isPassed) {
    require(isPassed? block.timestamp >= deadline: block.timestamp < deadline);
    _;
  }

  modifier notCompleted() {
    require(!exampleExternalContract.completed(), 'Contract is already completed'); 
    _;
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public passedDeadline(false) payable returns (bool) {
    // Add the amount to the `balances` mapping:
    balances[msg.sender] += msg.value;
    // Emit a `Stake(address,uint256)` event:
    emit Stake(msg.sender, msg.value);
    // Return the amount of ether to stake:
    return true;
  }

  // After some `deadline` allow anyone to call an `execute()` function
  // It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  function execute() public notCompleted passedDeadline(true) {
    if (address(this).balance >= threshold) {
      exampleExternalContract.complete{value: address(this).balance}();
    } else {
      openForWithdraw = true;
    }
  }

  // if the `threshold` was not met, allow everyone to call a `withdraw()` function
  function withdraw(address payable to) public {
    require(openForWithdraw); 
    uint256 amount = balances[to];
    balances[to] = 0;
    to.transfer(amount);
  }


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256) {
    // return 0;
    return (deadline > block.timestamp) ? (deadline - block.timestamp) : 0;
  }
}
