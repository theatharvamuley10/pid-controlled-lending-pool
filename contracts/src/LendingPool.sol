// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IPIDController} from "./interfaces/IPIDController.sol";

contract LendingPool is Ownable {
    /*//////////////////////////////////////////////////////////////
                             CUSTOM ERRORS
    //////////////////////////////////////////////////////////////*/
    error UNAUTHORIZED();

    /*//////////////////////////////////////////////////////////////
                           STORAGE VARIABLES
    //////////////////////////////////////////////////////////////*/

    uint256 private totalDeposited;
    uint256 private totalBorrowed;
    uint256 private interestRate;
    uint256 private targetUtilization;

    address private PID_CONTROLLER;

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier onlyPIDController() {
        if (msg.sender != PID_CONTROLLER) revert UNAUTHORIZED();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _PID_CONTROLLER) Ownable(msg.sender) {
        PID_CONTROLLER = _PID_CONTROLLER;
    }

    /*//////////////////////////////////////////////////////////////
                         USER FACING FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function deposit(uint256 amount) external {
        updateInterestRate();
    }

    function withdraw(uint256 amount) external {
        updateInterestRate();
    }

    function borrow(uint256 amount) external {
        updateInterestRate();
    }

    function repay(uint256 amount) external {
        updateInterestRate();
    }

    function getTotalDeposited() public view returns (uint256) {
        return totalDeposited;
    }

    function getTotalBorrowed() public view returns (uint256) {
        return totalBorrowed;
    }

    function getInterestRate() public view returns (uint256) {
        return interestRate;
    }

    function getTargetUtilization() public view returns (uint256) {
        return targetUtilization;
    }

    /*//////////////////////////////////////////////////////////////
                       NON USER FACING FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function updateInterestRate() internal {
        interestRate = IPIDController(PID_CONTROLLER).computeNewInterestRate(
            interestRate, targetUtilization, totalDeposited, totalBorrowed
        );
    }

    /*//////////////////////////////////////////////////////////////
                             ADMIN CONTROL
    //////////////////////////////////////////////////////////////*/
    function setPIDController(address _PID_CONTROLLER) external onlyOwner {
        PID_CONTROLLER = _PID_CONTROLLER;
    }

    function setTargetUtilization(uint256 _targetUtilization) external onlyOwner {
        targetUtilization = _targetUtilization;
    }
}
