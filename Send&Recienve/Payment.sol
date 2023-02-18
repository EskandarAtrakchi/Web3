pragma solidity ^0.8.0;

import "./IERC20.sol";

contract TokenPayment {
    address public tokenAddress;
    uint public paymentAmount;
    mapping(address => bool) public paid;

    constructor(address _tokenAddress, uint _paymentAmount) {
        tokenAddress = _tokenAddress;
        paymentAmount = _paymentAmount;
    }

    function pay() external payable {
        require(msg.value == paymentAmount, "Payment amount is incorrect");
        require(!paid[msg.sender], "You have already paid");

        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));

        paid[msg.sender] = true;
    }
}
