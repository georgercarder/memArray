//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

contract MemArray {

	uint256 constant private byteSize = 8;
	uint256 constant private wordSize = 32;
	uint256 constant private dataSize = 32; // 32 `length`

	function bytesToUint256(byte[] memory arr, uint256 from, uint256 to) private pure returns(uint256) {
		uint256 ret;
		uint256 range = to - from;
		for (uint256 i = from; i < to; i++) {
			ret |= uint256(bytes32(arr[i])) >> (byteSize * (range-(i-from)-1)); // endianness :(
		}
		return ret;
	}

 	function getArrayLength(byte[] memory arr) private pure returns(uint256) {
		return bytesToUint256(arr, 0, wordSize); // from, to
	} 

	function copy(byte[] memory dst, byte[] memory src) private pure returns(byte[] memory) {
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

	function allocate(uint256 targetLen) private pure returns(byte[] memory){
		return new byte[](targetLen);	
	}

	function Uint256IntoArr(byte[] memory arr, uint256 from, uint256 to, uint256 value) private pure returns(byte[] memory) {
		bytes32 bValue = bytes32(value);
		uint256 range = to - from;
		for (uint256 i = from; i < to; i++) {
			arr[i] = bValue[range-(i-from)-1];  // endianness
		}	
		return arr;
	}

	function setLength(byte[] memory arr, uint256 length) private pure returns(byte[] memory) {
		return Uint256IntoArr(arr, 0, wordSize, length); // from, to
	}

	function push(byte[] memory arr, byte value) internal returns(byte[] memory) {
 		uint256 sizeArr = arr.length; // total allocated
		if (sizeArr < wordSize) {
			arr = allocate(pow2(6)); 
			// enough for `length` data word and initial 32 bytes
		}
		uint256 lenArr = getArrayLength(arr);
		if (lenArr >= (sizeArr - dataSize)) { // there is no room!
			byte[] memory newArr = allocate(2*sizeArr);	
			newArr = copy(newArr, arr);
			arr = newArr;
		} // now there is room
	        uint256 idx = lenArr+dataSize;
		arr[idx] = value;
		lenArr++;
		arr = setLength(arr, lenArr);
		return arr;
  	}

	function pop(byte[] memory arr) internal pure returns(byte, bool) {
		bool ok = true;
		byte ret;
		uint256 lenArr = getArrayLength(arr);
		if (lenArr == 0) {
			return (ret, !ok);		
		} 
		uint256 idx = lenArr-1;
		ret = arr[idx];
		arr[idx] = byte(0x00); // delete
		lenArr--;
		setLength(arr, lenArr);
		return (ret, ok);
	}
}
