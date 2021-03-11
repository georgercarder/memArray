//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";
import "./MemArray.sol";


contract UseMemArray is MemArray {
	//using MemArray for uint256;

  constructor() {
  }

  function demo() external {
  	byte[] memory arr;
	push(arr, byte(0x01));
       /*uint256 a = 1;
       uint256 b= 2;
       uint256 c = a.add(b);
       c = c;*/
  }
}
