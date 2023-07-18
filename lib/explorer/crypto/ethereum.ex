defmodule Explorer.Crypto.Ethereum do
  alias Explorer.Crypto.Ethereum.Crate

  @spec recover_address(binary, binary) :: {:ok, binary} | {:error, term}
  def recover_address(signature, message) do
    Crate.recover_address(signature, message)
  end
end
