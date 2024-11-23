// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IERC20 {
    function approve(address spender, uint256 amount) external returns(bool);
    function balanceOf(address account) external view returns(uint256);
    function transfer(address recipient, uint256 amount) external returns(bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
}

contract SimpleSwap {
    address private tokenA;
    address private tokenB;

    uint256 private reserveA;
    uint256 private reserveB;

    event AddLiquidity(address indexed provider, uint256 amountA, uint256 amountB);
    event RemoveLiquidity(address indexed provider, uint256 amountA, uint256 amountB);
    event SwapA(address indexed user, uint256 amountA, uint256 amountB);
    event SwapB(address indexed user, uint256 amountB, uint256 amountA);

    constructor(address _tokenA, address _tokenB, uint256 _initialReserveA, uint256 _initialReserveB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        reserveA = _initialReserveA;
        reserveB = _initialReserveB;
    }

    function addLiquidity(uint amountA, uint amountB) external {
        require(amountA > 0 && amountB > 0, "Both amounts must be greater than 0");
        require(IERC20(tokenA).balanceOf(msg.sender) >= amountA, "Not enough A tokens");
        require(IERC20(tokenB).balanceOf(msg.sender) >= amountB, "Not enough B tokens");

        require(IERC20(tokenA).transferFrom(msg.sender, address(this), amountA), "Failed to transfer A tokens");
        require(IERC20(tokenB).transferFrom(msg.sender, address(this), amountB), "Failed to transfer B tokens");

        reserveA += amountA;
        reserveB += amountB;

        emit AddLiquidity(msg.sender, amountA, amountB);
    }

    function removeLiquidity(uint liduidity) external {
        require(liduidity > 0, "Amount of liduidity must be greater than 0");

        uint amountA = (liduidity * reserveA) / (reserveA + reserveB);
        uint amountB = (liduidity * reserveB) / (reserveA + reserveB);

        require(amountA > 0 && amountB > 0, "Token reserves insufficient");

        reserveA -= amountA;
        reserveB -= amountB;

        require(IERC20(tokenA).transfer(msg.sender, amountA), "Failed to transfer A tokens");
        require(IERC20(tokenB).transfer(msg.sender, amountB), "Failed to transfer B tokens");

        emit RemoveLiquidity(msg.sender, amountA, amountB);
    }

    function swap(uint amountA) external {
        require(amountA > 0, "Amount must be greater than 0");

        uint amountB = getAmountB(amountA);

        require(amountB > 0 && reserveB >= amountB, "Token reserves insufficient");

        require(IERC20(tokenA).transferFrom(msg.sender, address(this), amountA), "Failed to transfer A tokens");

        reserveA += amountA;
        reserveB -= amountB;

        require(IERC20(tokenB).transfer(msg.sender, amountB), "Failed to transfer B tokens");

        emit SwapA(msg.sender, amountA, amountB);
    }

    function getAmountB(uint amountA) private view returns(uint256) {
        return (reserveB * amountA) / reserveA;
    }
}

