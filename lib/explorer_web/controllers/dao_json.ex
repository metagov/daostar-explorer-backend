defmodule ExplorerWeb.DAOJSON do
  alias ExplorerWeb.AttestationIssuerJSON

  def show(%{dao: dao}) do
    %{
      "@context": "https://daostar.org/schemas",
      name: dao.name,
      attestationIssuerURIs: AttestationIssuerJSON.index(dao)
    }
  end
end
