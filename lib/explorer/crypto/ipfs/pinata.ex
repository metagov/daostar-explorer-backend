defmodule Explorer.Crypto.IPFS.Pinata do
  @endpoint "https://api.pinata.cloud"

  alias Explorer.Env

  def pin_object(object) do
    client()
    |> Tesla.post("/pinning/pinJSONToIPFS", object)
    |> case do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, body}

      error ->
        Explorer.Log.error(__MODULE__, error)
        {:error, :bad_request}
    end
  end

  defp client do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, @endpoint},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer #{token()}"}]}
    ])
  end

  defp token do
    Env.load(:pinata, :jwt)
  end
end
