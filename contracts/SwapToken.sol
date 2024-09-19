// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;


contract SwapToken {
    enum Order {
        createdOrder,
        OrderFulfiled
    }

        enum OrderStatus {
        Open,
        Closed,
        Pending
    }

    uint public totalOrders;

    struct OrderSwap {
        uint orderId;
        address depositor;
        address depositorToken;
        uint depositedAmount;
        address requiredToken;
        uint requiredAmount;
        address fulfilledBy;
        Order _orderType;
        OrderStatus status;
    }

      mapping(uint => OrderSwap) OrderIdToOrders; //Order => Order

    constructor() {}
}