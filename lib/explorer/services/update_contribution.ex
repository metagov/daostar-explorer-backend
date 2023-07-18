defmodule Explorer.Services.UpdateContribution do
  alias Explorer.Accounts
  alias Explorer.Activity
  alias Explorer.Crypto.Ethereum

  def perform(contribution_id, params, signature) do
    with {:ok, eth_address} <- recover_address(signature, contribution_id),
         {:ok, user} <- get_user(eth_address),
         {:ok, contribution} <- get_contribution(contribution_id),
         true <- contribution.user_id == user.id do
      update_contribution(contribution_id, params)
    else
      false ->
        {:error, :unauthorized}

      error ->
        error
    end
  end

  defp recover_address(signature, contribution_id) do
    Ethereum.recover_address(signature, contribution_id)
  end

  defp get_user(eth_address) do
    Accounts.get_user(eth_address)
  end

  defp get_contribution(contribution_id) do
    Activity.get_contribution(contribution_id)
  end

  defp update_contribution(contribution_id, params) do
    # IMPORTANT: Due to time constraints we're consciously assuming that
    # any input at this point means it's a valid and minted tx.
    #
    # This is not necessarily true:
    # 1. The user input might not be a transaction
    # 2. The transaction might be in the pool and be dropped
    # 3. We never check if the transaction was issued by the same user
    # 4. We assume the user sends us the correct issuer_uid
    #
    # The solution for this is to:
    # 1. make an API request in this module for the tx hash
    # 2. check if the owner matches the user address
    # 3. mark this as :minting and add an Oban job
    #    that runs every 30s and marks the contribution as :minted
    #    after 12 blocks and updates the issuer_uid field from the tx receipt
    Activity.update_contribution(contribution_id, %{
      tx_hash: params["tx_hash"],
      issuer_uid: params["issuer_uid"],
      status: :minted
    })
  end
end
