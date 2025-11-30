🏦 Secure Token Vault (Aiken)
Overview

A secure token vault smart contract written in Aiken for Cardano.

It allows users to deposit tokens, perform partial withdrawals, and ensures secure management of funds with on-chain validation.

Key Features:

✅ Partial withdrawals with updated vault state

✅ Minimum ADA enforcement on continuing outputs

✅ Tracks withdrawal history (who, amount, timestamp)

✅ Owner-controlled vault closure

✅ Single continuing output enforcement to prevent double-spending

Types

VaultDatum – state of the vault:

owner: Vault owner’s PubKeyHash

token: AssetClass stored in the vault

min_ada: Minimum ADA required

total_tokens: Current token balance

withdrawals: List of past withdrawals

VaultRedeemer – vault actions:

Withdraw amount – partial token withdrawal

Close – close the vault (owner only)

Usage

Deposit Tokens: Send ADA + tokens to the vault with VaultDatum.

Withdraw Tokens: Call the vault with Withdraw amount.

Close Vault: Owner calls Close to retrieve remaining tokens & ADA.

Tests

Single deposits & withdrawals

Partial withdrawals by multiple users

Owner-only closure validation

Minimum ADA checks

Prevent double satisfaction of outputs