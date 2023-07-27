defmodule Explorer.Crypto.Reputable.Provider.Firestore do
  @issuer "reputable"
  @endpoint "https://firestore.googleapis.com/v1/projects/reputable-f7202/databases/(default)/documents/completeAttestationURI/"

  use Tesla

  plug Tesla.Middleware.BaseUrl, @endpoint
  plug Tesla.Middleware.JSON

  def fetch(user) do
    get("/#{user.eth_address}")
  end

  def parse(user, %{"fields" => %{"reputation" => reputation}}) do
    parsed_reputation =
      get_in(reputation, ["arrayValue", "values"])
      |> Enum.map(fn %{"mapValue" => %{"fields" => fields}} ->
        %{
          issuer: @issuer,
          issuer_uid: get_in(fields, ["issuerID", "stringValue"]),
          issuer_uri: get_in(fields, ["issuerURI", "stringValue"]),
          score: get_in(fields, ["score", "integerValue"]),
          proof: get_in(fields, ["proof", "stringValue"]),
          expiration: get_in(fields, ["expiration", "stringValue"]),
          user_id: user.id
        }
      end)

    {:ok, parsed_reputation}
  end

  def parse(_, _), do: {:error, :bad_format}
end
