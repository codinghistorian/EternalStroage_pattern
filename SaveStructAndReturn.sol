// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract SaveStructAndReturn {

    struct EternalStorage {
        mapping(bytes32 => bytes32) values;
    }

    struct Check {
        uint256 a;
        uint256 b;
        uint256 c;
        mapping(bytes32 => bytes32) values;
    }
    uint256 internal randomNum; // slot 0
    // Eternal storage
    EternalStorage internal _eternalStorage; // slot1

    Check internal _check; //slot 2

    // addresses of the methods implementations
    mapping(bytes4 => address) internal _methodsImplementations; //slot3

    function setStruct(bytes32 slot, bytes32[] calldata values) external {
        uint256 valueLength = values.length;
            assembly {
                sstore(slot, valueLength)
            }
        for (uint i = 0; i < values.length; i++) {  //for loop example
            uint256 sugar = i + 1;
            bytes32 inputValue = values[i];
            assembly {
                let nextSlot := add(sugar, slot)
                sstore(nextSlot, inputValue)
            }
      }
    }
    function checkStorage(bytes32 slot) public view returns (bytes32) {
        assembly {
            let firstValue := sload(slot)
            mstore(0x00, firstValue)
            return(0x00, 32)
        }
    }
    function getStructValues(bytes32 slot) public view returns (bytes32[] memory) {
        uint256 structLength;
        uint256 slotUint = uint256(slot);
        assembly {
            structLength := sload(slotUint)
            let fmp := 0x40
            mstore(fmp, 0x20)
            mstore(add(fmp,0x20), structLength)
            for { let i } lt(i, structLength) { i := add(i, 1) } { 
                let newSlot := add(slotUint, add(i, 1))
                let value := sload(newSlot)
                let newMemoryLo := add(add(fmp,0x40), mul(32, i))
                mstore(newMemoryLo, value)
            }
            return(fmp, add(mul(32, structLength),0x40))
        }
    }

    function bytes32ArrayTest(bytes32[] calldata input) public pure returns (bytes32[] memory) {
        // bytes32[] memory hello;
        // hello[0] = (0x4c8f18581c0167eb90a761b4a304e009b924f03b619a0c0e8ea3adfce20aee64);
        // hello[1] = (0x111118581c0167eb90a761b4a304e009b924f03b619a0c0e8ea3adfce20aee64);
        bytes32[] memory hello = input;
        return hello;
    }
   
   

    function addValuesTocheck() external {
        _check.values[0x4c8f18581c0167eb90a761b4a304e009b924f03b619a0c0e8ea3adfce20aee64] = 0x111118581c0167eb90a761b4a304e009b924f03b619a0c0e8ea3adfce20aee64;
    }

    function eraseValuesTocheck() external {
        _check.values[0x4c8f18581c0167eb90a761b4a304e009b924f03b619a0c0e8ea3adfce20aee64] = 0x0000000000000000000000000000000000000000000000000000000000000000;
    }

    function addEternalStorage() external {
        _eternalStorage.values[0x4c8f18581c0167eb90a761b4a304e009b924f03b619a0c0e8ea3adfce20aee64] = 0x4c8f18581c0167eb90a761b4a304e009b924f03b619a0c0e8ea3adfce20aee64;
    }
    function checkSlot1() external pure returns (uint256) {
        assembly {
            let z := _eternalStorage.slot
            mstore(0x0, z)
            return(0x0, 32)
        }
    }
    function checkSlot2() external pure returns (uint256) {
        assembly {
            let z := _check.slot
            mstore(0x0, z)
            return(0x0, 32)
        }
    }
    function checkSlot3() external pure returns (uint256) {
        assembly {
            let z := _methodsImplementations.slot
            mstore(0x0, z)
            return(0x0, 32)
        }
    }

    function checkValue1() external view returns (bytes32) {
        assembly {
            let z := _eternalStorage.slot
            let returnValue := sload(z)
            mstore(0x0, returnValue)
            return(0x0, 32)
        }
    }

    function checkValue2() external view returns (bytes32) {
        assembly {
            let z := _check.slot
            let returnValue := sload(z)
            mstore(0x0, returnValue)
            return(0x0, 32)
        }
    }

    function checkValue3() external view returns (bytes32) {
        assembly {
            let z := _methodsImplementations.slot
            let returnValue := sload(z)
            mstore(0x0, returnValue)
            return(0x0, 32)
        }
    }

}

 
 
