defmodule Explorer.Crypto.IPFS.Gateway do
  @endpoint "https://ipfs.io/ipfs"
  @scheme "ipfs://"

  use Tesla

  plug Tesla.Middleware.BaseUrl, @endpoint
  plug Tesla.Middleware.JSON

  def get_object(@scheme <> cid) do
    get_object(cid)
  end

  def get_object(cid) do
    case get("/#{cid}") do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, body}

      _error ->
        {:error, :not_found}
    end
  end
end
