// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TaskBounty {
    struct Bounty {
        uint256 id;
        address creator;
        string title;
        string description;
        uint256 reward;
        address claimant;
        bool claimed;
        bool completed;
        bool paid;
    }

    mapping(uint256 => Bounty) public bounties;
    uint256 public bountyCount;

    event BountyCreated(uint256 indexed bountyId, address creator, uint256 reward);
    event BountyClaimed(uint256 indexed bountyId, address claimant);
    event BountyCompleted(uint256 indexed bountyId);
    event BountyPaid(uint256 indexed bountyId, address claimant);

    function createBounty(string memory _title, string memory _description) external payable returns (uint256) {
        require(msg.value > 0, "Must fund bounty");

        uint256 bountyId = bountyCount++;

        bounties[bountyId] = Bounty({
            id: bountyId,
            creator: msg.sender,
            title: _title,
            description: _description,
            reward: msg.value,
            claimant: address(0),
            claimed: false,
            completed: false,
            paid: false
        });

        emit BountyCreated(bountyId, msg.sender, msg.value);

        return bountyId;
    }

    function claimBounty(uint256 _bountyId) external {
        Bounty storage bounty = bounties[_bountyId];
        require(!bounty.claimed, "Already claimed");

        bounty.claimant = msg.sender;
        bounty.claimed = true;

        emit BountyClaimed(_bountyId, msg.sender);
    }

    function completeBounty(uint256 _bountyId) external {
        Bounty storage bounty = bounties[_bountyId];
        require(msg.sender == bounty.creator, "Only creator");
        require(bounty.claimed && !bounty.completed, "Invalid state");

        bounty.completed = true;
        bounty.paid = true;
        payable(bounty.claimant).transfer(bounty.reward);

        emit BountyCompleted(_bountyId);
        emit BountyPaid(_bountyId, bounty.claimant);
    }

    function getBounty(uint256 _bountyId) external view returns (Bounty memory) {
        return bounties[_bountyId];
    }
}
