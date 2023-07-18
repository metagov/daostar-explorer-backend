defmodule Explorer.Activity do
  import Ecto.Query
  import Explorer.Storage

  alias Explorer.Activity.Fetcher
  alias Explorer.Activity.Contribution
  alias Explorer.Repo

  def fetch_contributions(eth_address) do
    Fetcher.perform(eth_address)
  end

  def get_contribution(id) do
    Contribution
    |> Repo.get(id)
    |> normalize()
  end

  def get_contribution(issuer, issuer_uid) do
    Contribution
    |> Repo.get_by(issuer: issuer, issuer_uid: issuer_uid)
    |> normalize()
  end

  def get_contributions(eth_address) do
    Contribution
    |> join(:inner, [c], u in assoc(c, :user), as: :u)
    |> where([u: u], u.eth_address == ^eth_address)
    |> select([c, u: u], c)
    |> Repo.all()
  end

  def create_contribution(attrs) do
    %Contribution{}
    |> Contribution.changeset(attrs)
    |> Repo.insert()
  end

  def create_unminted_contribution(attrs) do
    %Contribution{}
    |> Contribution.unminted_changeset(attrs)
    |> Repo.insert()
  end

  def update_contribution(%Contribution{} = contribution, attrs) do
    contribution
    |> Contribution.update_changeset(attrs)
    |> Repo.update()
  end
end
