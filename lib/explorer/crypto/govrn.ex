defmodule Explorer.Crypto.Govrn do
  @issuer "govrn"
  @issuer_uri "https://govrn.app"

  alias Explorer.Accounts.User

  def issuer, do: @issuer

  def issuer_uri, do: @issuer_uri
  def issuer_uri(%User{eth_address: eth_address}), do: issuer_uri(eth_address)
  def issuer_uri(eth_address), do: "#{@issuer_uri}/#{eth_address}"
end
