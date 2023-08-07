defmodule Explorer.DAOs.AttestationIssuer do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__
  alias Explorer.DAOs.DAO

  schema "attestation_issuers" do
    field :issuer_uri, :string

    belongs_to :dao, DAO

    timestamps()
  end

  @doc false
  def changeset(%AttestationIssuer{} = attestation_issuer, attrs) do
    attestation_issuer
    |> cast(attrs, [:dao_id, :issuer_uri])
    |> validate_required([:dao_id, :issuer_uri])
  end
end
