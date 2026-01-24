# TaskBounty

Bounty board for task completion rewards on Base and Stacks.

## Features

- Create funded bounties
- Claim tasks
- Mark completion
- Automatic payouts

## Contract Functions

### Base (Solidity)
- `createBounty(title, description)` - Create funded bounty
- `claimBounty(bountyId)` - Claim task
- `completeBounty(bountyId)` - Mark complete and pay
- `getBounty(bountyId)` - Get bounty details

### Stacks (Clarity)
- `create-bounty` - Create STX bounty
- `claim-bounty` - Claim task
- `complete-bounty` - Complete and payout
- `get-bounty` - Fetch bounty info

## Quick Start

```bash
pnpm install
pnpm dev
```

## Deploy

```bash
pnpm deploy:base
pnpm deploy:stacks
```

## License

MIT
