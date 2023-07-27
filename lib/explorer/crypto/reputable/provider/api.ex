defmodule Explorer.Crypto.Reputable.Provider.API do
  @endpoint "https://reputable-swagger-api.onrender.com"

  use Tesla

  plug Tesla.Middleware.BaseUrl, @endpoint
  plug Tesla.Middleware.JSON

  def fetch(%{reputable_seller_id: nil}), do: {:error, :not_found}

  def fetch(user) do
    get("/get_and_verify_reputation",
      query: [sellerId: user.reputable_seller_id]
    )
  end

  def parse(user, %{"reputation" => reputation}) do
    parsed_reputation =
      Enum.map(reputation, fn entry ->
        %{
          issuer: entry["issuer"],
          issuer_uid: to_string(entry["issuerUid"]),
          issuer_uri: entry["issuerUri"],
          proof: entry["proof"],
          score: entry["score"],
          expiration: entry["expiration"],
          user_id: user.id
        }
      end)

    {:ok, parsed_reputation}
  end
end
