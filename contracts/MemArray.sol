//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

contract MemArray {

	uint256 constant private byteSize = 8;
	uint256 constant private wordSize = 32;
	uint256 constant private dataSize = 32; // 32 `length`

	function bytesToUint256(bytes memory arr, uint256 from, uint256 to) private pure returns(uint256) {
		uint256 ret;
		uint256 range = to - from;
		for (uint256 i = from; i < to; i++) {
			ret |= uint256(bytes32(arr[i])) >> (byteSize * (range-(i-from)-1)); // endianness :(
		}
		return ret;
	}

 	function getArrayLength(bytes memory arr) private pure returns(uint256) {
		return bytesToUint256(arr, 0, wordSize); // from, to
	} 

	function copy(bytes memory dst, bytes memory src) private pure returns(bytes memory) {
 		uint256 sizeSrc = src.length; // total allocated
		for (uint256 i = 0; i < sizeSrc; i++) {
			dst[i] = src[i];
		}
		return dst;
	}

       	function pow2(uint256 exp) private returns(uint256) {
		if (exp < 1) {
			return 1;
		}
		return 2 * pow2(exp - 1);
	}

	function allocate(uint256 targetLen) private pure returns(bytes memory){
		return new bytes(targetLen);	
	}

	function Uint256IntoArr(bytes memory arr, uint256 from, uint256 to, uint256 value) private pure returns(bytes memory) {
		bytes32 bValue = bytes32(value);
		uint256 range = to - from;
		for (uint256 i = from; i < to; i++) {
			arr[i] = bValue[range-(i-from)-1];  // endianness
		}	
		return arr;
	}

	function setLength(bytes memory arr, uint256 length) private pure returns(bytes memory) {
		return Uint256IntoArr(arr, 0, wordSize, length); // from, to
	}

	function push(bytes memory arr, byte value) internal returns(bytes memory) {
 		uint256 sizeArr = arr.length; // total allocated
		if (sizeArr < wordSize) {
			arr = allocate(pow2(6)); 
			// enough for `length` data word and initial 32 bytes
		}
		uint256 lenArr = getArrayLength(arr);
		if (lenArr >= (sizeArr - dataSize)) { // there is no room!
			bytes memory newArr = allocate(2*sizeArr);	
			newArr = copy(newArr, arr);
			arr = newArr;
		} // now there is room
	        uint256 idx = lenArr+dataSize;
		arr[idx] = value;
		lenArr++;
		arr = setLength(arr, lenArr);
		return arr;
  	}

	// private unchecked
	function _at(bytes memory arr, uint256 idx) private pure returns(byte) {
		return arr[idx+dataSize];	
	}

	// private unchecked
	function _delete(bytes memory arr, uint256 idx) private pure returns(bytes memory) {
		arr[idx+dataSize] = byte(0x00); // delete
		return arr;
	}

	function pop(bytes memory arr) internal pure returns(bytes memory, byte, bool) {
		bool ok = true;
		byte ret;
		uint256 lenArr = getArrayLength(arr);
		if (lenArr == 0) {
			return (arr, ret, !ok);		
		} 
		uint256 idx = lenArr-1;
		ret = _at(arr, idx);
		arr = _delete(arr, idx);
		lenArr--;
		arr = setLength(arr, lenArr);
		return (arr, ret, ok);
	}
}
