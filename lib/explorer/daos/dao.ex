defmodule Explorer.DAOs.DAO do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__
  alias Explorer.DAOs.AttestationIssuer

  schema "daos" do
    field :slug, :string
    field :name, :string
    field :description, :string

    has_many :attestation_issuers, AttestationIssuer

    timestamps()
  end

  @doc false
  def changeset(%DAO{} = dao, attrs) do
    dao
    |> cast(attrs, [:slug, :name, :description])
    |> validate_required([:slug, :name])
    |> unique_constraint(:slug, downcase: true)
  end
end
