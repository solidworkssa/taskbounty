// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TaskBounty Contract
/// @author solidworkssa
/// @notice Decentralized task marketplace with crypto bounties.
contract TaskBounty {
    string public constant VERSION = "1.0.0";


    struct Bounty {
        address issuer;
        string description;
        uint256 amount;
        bool claimed;
        address claimant;
    }
    
    Bounty[] public bounties;
    
    function createBounty(string memory _desc) external payable {
        bounties.push(Bounty({
            issuer: msg.sender,
            description: _desc,
            amount: msg.value,
            claimed: false,
            claimant: address(0)
        }));
    }
    
    function claimBounty(uint256 _id, address payable _claimant) external {
        Bounty storage b = bounties[_id];
        require(msg.sender == b.issuer, "Only issuer can approve");
        require(!b.claimed, "Already claimed");
        
        b.claimed = true;
        b.claimant = _claimant;
        _claimant.transfer(b.amount);
    }

}
