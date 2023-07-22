defmodule Explorer.Services.CreateContribution do
  alias Explorer.Activity
  alias Explorer.Accounts
  alias Explorer.Crypto.Ethereum
  alias Explorer.Crypto.Govrn
  alias Explorer.Crypto.IPFS

  def perform(params, signature) do
    with {:ok, eth_address} <- recover_address(signature, params),
         {:ok, user} <- get_or_create_user(eth_address),
         metadata <- build_metadata(params),
         {:ok, metadata_uri} <- pin_metadata(metadata),
         params <- build_params(params, user, metadata, metadata_uri) do
      Activity.create_unminted_contribution(params)
    end
  end

  defp recover_address(signature, params) do
    message = get_signable_message(params)

    Ethereum.recover_address(signature, message)
  end

  defp get_signable_message(params) do
    [
      params["title"],
      params["description"],
      params["category"],
      params["date_of_engagement"],
      params["external"]
    ]
    |> Stream.reject(&is_nil/1)
    |> Enum.join(",")
  end

  defp get_or_create_user(eth_address) do
    Accounts.get_or_create_user(eth_address)
  end

  defp build_metadata(params) do
    Govrn.Schema.V2RC1.build_metadata(%{
      title: params["title"],
      description: params["description"],
      date_of_engagement: params["date_of_engagement"],
      category: params["category"],
      external: params["external"]
    })
  end

  defp pin_metadata(metadata) do
    with {:ok, %{"IpfsHash" => metadata_uri}} <- IPFS.pin_object(metadata) do
      {:ok, metadata_uri}
    end
  end

  defp build_params(params, user, metadata, metadata_uri) do
    %{
      issuer: Govrn.issuer(),
      issuer_uri: Govrn.issuer_uri(user),
      version: Govrn.Schema.V2RC1.version(),
      issuer_uid: nil,
      title: params["title"],
      description: params["description"],
      category: params["category"],
      date_of_engagement: params["dateOfEngagement"],
      contributors: [],
      contributor_signatures: [],
      metadata_uri: metadata_uri,
      metadata: metadata,
      external: params["external"],
      tx_hash: nil,
      user_id: user.id
    }
  end
end
