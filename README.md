# 07-taskbounty - Base Native Architecture

> **Built for the Base Superchain & Stacks Bitcoin L2**

This project is architected to be **Base-native**: prioritizing onchain identity, low-latency interactions, and indexer-friendly data structures.

## 🔵 Base Native Features
- **Smart Account Ready**: Compatible with ERC-4337 patterns.
- **Identity Integrated**: Designed to resolve Basenames and store social metadata.
- **Gas Optimized**: Uses custom errors and batched call patterns for L2 efficiency.
- **Indexer Friendly**: Emits rich, indexed events for Subgraph data availability.

## 🟠 Stacks Integration
- **Bitcoin Security**: Leverages Proof-of-Transfer (PoX) via Clarity contracts.
- **Post-Condition Security**: Strict asset movement checks.

---
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
