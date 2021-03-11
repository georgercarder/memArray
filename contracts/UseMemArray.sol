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
	arr = push(arr, byte(0x01));
	arr = push(arr, byte(0x22));

	(byte p, bool ok) = pop(arr);
	require(ok, "should be ok!!");
	if (ok) {
		require(p == byte(0x22), "byte should equal (1)");	
	}
	/*(p, ok) = pop(arr);
	require(ok, "should be ok!!");
	if (ok) {
		require(p == byte(0x01), "byte should equal (2)");	
	}
	(, ok) = pop(arr);
	require(!ok, "should not be ok!!");*/
  }
}
