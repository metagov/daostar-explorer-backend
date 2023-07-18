defmodule Explorer.Crypto.IPFS do
  alias Explorer.Crypto.IPFS.Gateway
  alias Explorer.Crypto.IPFS.Pinata

  defdelegate get_object(cid), to: Gateway
  defdelegate pin_object(object), to: Pinata
end
