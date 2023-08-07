defmodule ExplorerWeb.DAOJSON do
  alias ExplorerWeb.AttestationIssuerJSON

  def show(%{dao: dao}) do
    %{
      "@context": "https://daostar.org/schemas",
      type: "DAO",
      name: dao.name,
      description: dao.description,
      attestationIssuerURIs: AttestationIssuerJSON.index(dao)
    }
  end
end
