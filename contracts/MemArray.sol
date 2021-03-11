//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

contract MemArray {

	uint256 constant private byteSize = 8;
	uint256 constant private wordSize = 32;
	uint256 constant private dataSize = 64; // 2 * 32 `length`, `idx`

	function bytesToUint256(byte[] memory arr, uint256 from, uint256 to) private returns(uint256) {
		uint256 ret;
		for (uint256 i = 0; i < wordSize; i++) {
			ret |= uint256(bytes32(arr[i])) << (byteSize * i);	
		}	
		return ret;
	}

 	function getArrayLength(byte[] memory arr) private returns(uint256) {
		return bytesToUint256(arr, 0, wordSize); // from, to
	} 

	function getIdx(byte[] memory arr) private returns(uint256) {
		return bytesToUint256(arr, wordSize, 2*wordSize); // from, to
	}

	function copy(byte[] memory to, byte[] memory from) private {
 		uint256 sizeFrom = from.length; // total allocated
		for (uint256 i = 0; i < sizeFrom; i++) {
			to[i] = from[i];
		}
	}

       	function pow2(uint256 exp) private returns(uint256) {
		if (exp < 1) {
			return 1;
		}
		return 2 * pow2(exp - 1);
	}

	function allocate(uint256 targetLen) private returns(byte[] memory){
		return new byte[](targetLen);	
	}

	function setLength(byte[] memory arr, uint256 length) private {
		for (uint256 i = 0; i < wordSize; i++) {
			arr[i] = byte(bytes32(length >> (byteSize * i))[0]);
		}	
	}

	function push(byte[] memory arr, byte value) internal {
 		uint256 sizeArr = arr.length; // total allocated
		if (sizeArr < wordSize) {
			arr = allocate(pow2(7)); 
			// enough for `length`, `idx` data words and initial 64 bytes
			setLength(arr, 64);
		}
		uint256 lenArr = getArrayLength(arr);
		if (lenArr == (sizeArr - dataSize)) { // there is no room!
			newArr = allocate(2*sizeArr);	
			copy(newArr, arr);
			arr = newArr;
		}
		uint256 idx = getIdx(arr);
		idx++;
		arr[idx] = value;
  	}
}
