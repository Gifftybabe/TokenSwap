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


 function createOrder(
        uint _depositedAmount,
        address _depositorToken,
        uint _requestedAmount,
        address _requestedToken
    ) external {
        require(msg.sender != address(0), "Address zero detected.");
        require(_depositorToken != address(0), "Address zero detected.");
        require(_requestedToken != address(0), "Address zero detected.");
        require(_depositedAmount > 0, "Invalid Deposit Amount");
        require(_requestedAmount > 0, "Invalid Requested Amount");

        require(
            IERC20(_depositorToken).transferFrom(
                msg.sender,
                address(this),
                _depositedAmount
            ),
            "Transfer Failed"
        );

        createTransaction(
            _depositedAmount,
            _depositorToken,
            _requestedAmount,
            _requestedToken,
            Order.OrderCreated,
            OrderStatus.Open
        );
    
    }
}