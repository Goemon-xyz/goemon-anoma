# Anoma <> Goemon - Builder Integration

## Description of Anoma

Anoma is a distributed operating system for building intent-centric applications. It unifies underlying blockchains into a single development environment, ending the fragmentation of state and users that limits today's decentralized applications. By enabling generalized intents across the Ethereum ecosystem and beyond, Anoma makes a more user-friendly, app-centric future possible for Web3.

## Description of Goemon

GOEMON is an Intent-Based Options Liquidity Layer. We unify options liquidity from CEXs, DEXs, and MMs, providing seamless access to advanced strategies with just a few clicks. We leverage intents for frictionless cross-chain execution.

## Initial integration

### Goal:
- Familiarity with Anoma's intent lifecycle (creation, propagation, settlement)

- Basic understanding of Juvix syntax and semantics.

- Utilize Anoma's generalized intentions to make deposits, withdrawals and settle orders.

### Integration Components:

### Smart Contracts (Juvix)

DepositIntent: A struct defining user deposit parameters such as chain, asset, amount, and recipient.
WithdrawIntent: A struct for withdrawal requests, including asset, amount, target chain, and target address.
Success Criteria:
User Signs Intent: The Goemon UI captures deposit/withdrawal details and the              user signs an intent.
Propagate to Anoma:The signed intents are submitted to Anoma's mempool via the anoma-client broadcast-intent command.
Settlement: Anoma validators match intents

### Order Book Integration

Define order types (e.g., limit, market) and matching logic within Anoma's state.
Orders are processed offchain via our options aggregation logic for the best price quote and batched settled onchain
Success Criteria:
Order Creation Intent: The Goemon UI captures deposit/withdrawal details and the              user signs an intent.
Broadcast Order Intent: The order intent is broadcast to Anoma and trigger order creation and matching offchain.
Settlement: Anoma validators match intents

### Goemon Frontend Integration

Future
- Use solvers for complete onchain orderbook and communicate cross chain
  
- Use solvers to interact with different protocols to create complex strategies

- Use solvers to aggregate liquidity across multiple dexes
 
### Run Juvix code locally

- Clone this repo and install Juvix 0.6.9-8b06157 and anoma node. Also install juvix extension in VS Code.
  
- Run `juvix build` which installs and compiles all the dependencies.
  
- To compile the code and see output run `juvix compile GoemonIntent.juvix -o GoemonIntent` or click play button from extension which compiles and runs anoma code.
