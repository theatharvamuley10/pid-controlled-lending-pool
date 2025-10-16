// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PIDController {
    uint256 k_p;
    uint256 k_i;
    uint256 k_d;

    uint256 accumulatedError;
    uint256 previousError;
    uint256 previousUpdateTimestamp;

    function computeNewInterestRate(
        uint256 interestRate,
        uint256 targetUtilization,
        uint256 totalDeposited,
        uint256 totalBorrowed
    ) external returns (uint256 updatedInterestRate) {
        uint256 currentUtilization = totalBorrowed / totalDeposited;
        uint256 e = currentUtilization - targetUtilization;

        uint256 u_p = k_p * e;

        accumulatedError += e;
        uint256 u_i = k_i * accumulatedError;

        uint256 timeElapsed = block.timestamp - previousUpdateTimestamp;
        uint256 delta_e = e - previousError;
        uint256 u_d = (k_d * delta_e) / timeElapsed;

        updatedInterestRate = interestRate + u_p + u_i + u_d;
    }
}
