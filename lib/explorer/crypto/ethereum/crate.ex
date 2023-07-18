defmodule Explorer.Crypto.Ethereum.Crate do
  @moduledoc """
  NIF implementation of the `ethereum` crate bundled with this app.

  Should not be invoked directly, this API should not be exposed.
  Other modules like `#{Explorer.Crypto.Ethereum}` should call it instead.
  """

  use Rustler, otp_app: :explorer, crate: :explorer_ethereum_crate

  @spec recover_address(binary, binary) :: {:ok, binary} | {:error, term}
  def recover_address(_, _), do: :erlang.nif_error(:nif_not_loaded)
end
