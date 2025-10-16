// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPIDController {
    function computeNewInterestRate(
        uint256 interestRate,
        uint256 targetUtilization,
        uint256 totalDeposited,
        uint256 totalBorrowed
    ) external returns (uint256);
}
