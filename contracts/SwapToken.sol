// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Interfaces/IERC20.sol";

contract TokenSwap {
    enum ActionType {
        Created,
        Fulfilled
    }

    enum OrderState {
        Open,
        Closed,
        Cancelled
    }

    uint public totalSwaps;

    struct SwapOrder {
        uint id;
        address initiator;
        address tokenOffered;
        uint amountOffered;
        address tokenRequested;
        uint amountRequested;
        address fulfiller;
        ActionType action;
        OrderState state;
    }

    struct Transaction {
        uint orderId;
        address token;
        uint amount;
        ActionType action;
        OrderState state;
    }

    mapping(uint => SwapOrder) public orders;
    mapping(address => Transaction[]) public userHistory;
    mapping(address => Transaction[]) public fulfillHistory;

    event SwapCreated(uint orderId, address indexed initiator, address tokenRequested, uint amountRequested);
    event SwapFulfilled(uint orderId, address indexed fulfiller);
    event SwapCancelled(uint orderId);

    function createSwap(
        uint _amountOffered,
        address _tokenOffered,
        uint _amountRequested,
        address _tokenRequested
    ) external {
        require(msg.sender != address(0), "Invalid address");
        require(_tokenOffered != address(0), "Invalid token offered");
        require(_tokenRequested != address(0), "Invalid token requested");
        require(_amountOffered > 0, "Amount offered must be greater than zero");
        require(_amountRequested > 0, "Amount requested must be greater than zero");

        require(
            IERC20(_tokenOffered).transferFrom(
                msg.sender,
                address(this),
                _amountOffered
            ),
            "Token transfer failed"
        );

        uint newOrderId = totalSwaps + 1;
        SwapOrder storage newOrder = orders[newOrderId];
        newOrder.id = newOrderId;
        newOrder.initiator = msg.sender;
        newOrder.tokenOffered = _tokenOffered;
        newOrder.amountOffered = _amountOffered;
        newOrder.tokenRequested = _tokenRequested;
        newOrder.amountRequested = _amountRequested;
        newOrder.action = ActionType.Created;
        newOrder.state = OrderState.Open;

        userHistory[msg.sender].push(
            Transaction({
                orderId: newOrderId,
                token: _tokenOffered,
                amount: _amountOffered,
                action: ActionType.Created,
                state: OrderState.Open
            })
        );

        totalSwaps = newOrderId;

        emit SwapCreated(newOrderId, msg.sender, _tokenRequested, _amountRequested);
    }

    function fulfillSwap(uint _orderId) external {
        require(orders[_orderId].id > 0, "Invalid order ID");
        require(
            orders[_orderId].initiator != msg.sender,
            "Initiator cannot fulfill own order"
        );
        require(
            orders[_orderId].state == OrderState.Open,
            "Order is not open"
        );

        orders[_orderId].state = OrderState.Closed;
        orders[_orderId].fulfiller = msg.sender;

        require(
            IERC20(orders[_orderId].tokenRequested).transferFrom(
                msg.sender,
                orders[_orderId].initiator,
                orders[_orderId].amountRequested
            ),
            "Token request transfer failed"
        );
        require(
            IERC20(orders[_orderId].tokenOffered).transfer(
                msg.sender,
                orders[_orderId].amountOffered
            ),
            "Token offer transfer failed"
        );

        fulfillHistory[msg.sender].push(
            Transaction({
                orderId: _orderId,
                token: orders[_orderId].tokenOffered,
                amount: orders[_orderId].amountOffered,
                action: ActionType.Fulfilled,
                state: OrderState.Closed
            })
        );

        emit SwapFulfilled(_orderId, msg.sender);
    }

    function cancelSwap(uint _orderId) external {
        require(orders[_orderId].id > 0, "Invalid order ID");
        require(
            orders[_orderId].state == OrderState.Open,
            "Order already processed"
        );
        require(
            orders[_orderId].initiator == msg.sender,
            "Only the initiator can cancel"
        );

        orders[_orderId].state = OrderState.Cancelled;

        require(
            IERC20(orders[_orderId].tokenOffered).transfer(
                orders[_orderId].initiator,
                orders[_orderId].amountOffered
            ),
            "Refund failed"
        );

        userHistory[msg.sender].push(
            Transaction({
                orderId: _orderId,
                token: orders[_orderId].tokenOffered,
                amount: orders[_orderId].amountOffered,
                action: ActionType.Created,
                state: OrderState.Cancelled
            })
        );

        emit SwapCancelled(_orderId);
    }
}
