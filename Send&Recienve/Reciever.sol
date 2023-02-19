// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IBEP20 {
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function decimals() external view returns (uint8);
}

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

        IBEP20 token = IBEP20(tokenAddress);
        uint tokenDecimals = token.decimals();
        uint tokenAmount = (10 ** tokenDecimals) * paymentAmount;
        require(token.transfer(msg.sender, tokenAmount), "Token transfer failed");

        paid[msg.sender] = true;
    }
}
