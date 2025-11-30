-- lib/types.ak

pub type WithdrawalRecord = (
  who PubKeyHash,
  amount Int,
  time Int
)

pub type VaultDatum = (
  owner PubKeyHash,
  token Token,
  min_ada Int,
  total_tokens Int,
  withdrawals [WithdrawalRecord]
)

pub enum VaultRedeemer = 
  Withdraw Int
  | Close
-- validators/m004val.ak

use lib/types.ak

pub validator vault(d: VaultDatum, r: VaultRedeemer, ctx: ScriptContext) -> Bool {
  const info = ctx.tx

  when r is
    Withdraw amt -> {
      amt > 0
      && amt <= d.total_tokens
      && (size info.signers) > 0
      && (size (continuing_outputs ctx)) == 1
      && validate_continuing_withdraw(d, amt, ctx)
      && validate_min_ada(d, ctx)
    }

    Close -> {
      list_contains(info.signers, d.owner)
    }
}

pub fn validate_continuing_withdraw(d: VaultDatum, amt: Int, ctx: ScriptContext) -> Bool {
  const outputs = continuing_outputs(ctx)

  when outputs is
    [out] -> {
      const maybe_datum = out.datum

      when maybe_datum is
        Some new_d -> {
          d.token == new_d.token
          && new_d.total_tokens == d.total_tokens - amt
          && (size new_d.withdrawals) == (size d.withdrawals + 1)
        }
        None -> false
    }
    _ -> false
}

pub fn validate_min_ada(d: VaultDatum, ctx: ScriptContext) -> Bool {
  const outputs = continuing_outputs(ctx)

  when outputs is
    [out] -> {
      out.value.lovelace >= d.min_ada
    }
    _ -> false
}
