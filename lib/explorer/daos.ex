defmodule Explorer.DAOs do
  import Ecto.Query
  import Explorer.Storage

  alias Explorer.DAOs.AttestationIssuer
  alias Explorer.DAOs.DAO
  alias Explorer.Repo

  def get_dao(slug, opts \\ []) do
    DAO
    |> where(slug: ^slug)
    |> include(opts)
    |> Repo.one()
    |> normalize()
  end

  def create_dao(attrs \\ %{}) do
    %DAO{}
    |> DAO.changeset(attrs)
    |> Repo.insert()
  end

  def get_attestation_issuer(id) do
    Repo.get(AttestationIssuer, id)
    |> normalize()
  end

  def create_attestation_issuer(attrs \\ %{}) do
    %AttestationIssuer{}
    |> AttestationIssuer.changeset(attrs)
    |> Repo.insert()
  end
end
