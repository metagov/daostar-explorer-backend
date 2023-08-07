defmodule ExplorerWeb.IssuerURIs.GovrnController do
  use ExplorerWeb, :controller

  action_fallback ExplorerWeb.FallbackController

  def show(conn, _params) do
    json(conn, %{
      "@context": "https://daostar.org/schemas",
      type: "issuer",
      name: "Govrn",
      description: "A service to track and record your DAO Contributions",
      "memberAttestationsURI:eth_address":
        "https://voyager-identity-api-staging.govrn.app/api/:eth_address"
    })
  end
end
