// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

contract Proxy {
    address public logicContractAddress;

    constructor(address _logicContractAddress) {
        logicContractAddress = _logicContractAddress;
    }

    fallback() external payable {
        address _impl = logicContractAddress;
        require(_impl != address(0), "Logic contract not set");
        assembly {
            // Call the logic contract
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    function upgrade(address _newLogicContract) external {
        logicContractAddress = _newLogicContract;
    }
}
