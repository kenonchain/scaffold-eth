// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  uint256 public constant tokensPerEth = 100;
  YourToken yourToken;

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  function buyTokens() public payable {
    uint256 amount = msg.value * tokensPerEth;
    uint256 tokenBalance = yourToken.balanceOf(address(this));
    
    require(amount <= tokenBalance, "Not enough tokens");
    yourToken.transfer(msg.sender, amount);
    BuyTokens(msg.sender, msg.value, amount);
  }

  function sellTokens(uint256 amount) public {
    require(amount <= yourToken.balanceOf(msg.sender), "Not enough tokens");
    require(amount <= address(this).balance * tokensPerEth, "Not enough eth of Vender");
    yourToken.transferFrom(msg.sender, address(this), amount);
    address(msg.sender).call{value: amount / tokensPerEth}("");
  }

  function withdraw() public onlyOwner {
    address(msg.sender).call{value: address(this).balance}("");
  }
}
