//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";
import "./MemArray.sol";


contract UseMemArray is MemArray {
	//using MemArray for uint256;
	byte public wall;

  constructor() {
  }

  function demo() external {
  	byte[] memory arr;
	arr = push(arr, byte(0x01));
	wall = arr[0];
	arr = push(arr, byte(0x22));

	wall = arr[0];
	byte p;
	bool ok;
	(arr, p, ok) = pop(arr);
	require(ok, "should be ok!!");
	if (ok) {
		wall = p;
		require(p == byte(0x22), "byte should equal (1)");	
	}
	(arr, p, ok) = pop(arr);
	require(ok, "should be ok!!");
	if (ok) {
		require(p == byte(0x01), "byte should equal (2)");	
	}
	(,, ok) = pop(arr);
	require(!ok, "should not be ok!!");
  }
}
