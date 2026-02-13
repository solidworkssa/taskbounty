// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/TaskBounty.sol";

contract TaskBountyTest is Test {
    TaskBounty public c;
    
    function setUp() public {
        c = new TaskBounty();
    }

    function testDeployment() public {
        assertTrue(address(c) != address(0));
    }
}
