// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./OrderedSwap.sol";  

contract SwapFactory {
     
    OrderedSwap[] allSwaps;

    function createSwap() external returns(OrderedSwap newSwap, uint256 length_) {
        newSwap = new OrderedSwap();

        allSwaps.push(newSwap);

        length_ = allSwaps.length;
    }

    function getAllSwaps() external view returns (OrderedSwap[] memory) {
        return allSwaps;
    }
}