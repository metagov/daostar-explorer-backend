defmodule Explorer.Contributions do
  import Explorer.Storage

  alias Explorer.Contributions.Fetcher
  alias Explorer.Contributions.Schema
  alias Explorer.Repo

  def fetch_contributions(eth_address) do
    Fetcher.perform(eth_address)
  end

  def get_contribution(id) do
    Repo.get(Schema, id)
    |> normalize()
  end

  def get_contribution(issuer, issuer_uid) do
    Repo.get_by(Schema, issuer: issuer, issuer_uid: issuer_uid)
    |> normalize()
  end

  def create_contribution(attrs) do
    %Schema{}
    |> Schema.changeset(attrs)
    |> Repo.insert()
  end
end
