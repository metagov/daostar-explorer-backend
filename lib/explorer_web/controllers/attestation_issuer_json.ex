defmodule ExplorerWeb.AttestationIssuerJSON do
  alias Explorer.DAOs.AttestationIssuer

  def index(%{attestation_issuers: attestation_issuers}) do
    Enum.map(attestation_issuers, &data/1)
  end

  defp data(%AttestationIssuer{} = issuer) do
    %{
      type: "AttestationIssuer",
      issuerURI: issuer.issuer_uri
    }
  end
end
