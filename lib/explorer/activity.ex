defmodule Explorer.Activity do
  import Ecto.Query
  import Explorer.Storage

  alias Explorer.Activity.AggregateReputation
  alias Explorer.Activity.Fetcher
  alias Explorer.Activity.Contribution
  alias Explorer.Repo

  #
  # Contributions
  #

  def fetch(eth_address) do
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

  def get_contributions(eth_address, opts \\ []) do
    statuses = opts[:status] || Contribution.statuses()

    Contribution
    |> join(:inner, [c], u in assoc(c, :user), as: :u)
    |> where([u: u], u.eth_address == ^eth_address)
    |> where([c], c.status in ^statuses)
    |> select([c, u: u], c)
    |> Repo.all()
  end

  def create_contribution(attrs) do
    %Contribution{}
    |> Contribution.changeset(attrs)
    |> Repo.insert()
  end

  def create_or_update_contribution(attrs, update_attrs) do
    on_conflict = [set: Enum.into(update_attrs, [])]

    %Contribution{}
    |> Contribution.changeset(attrs)
    |> Repo.insert(
      on_conflict: on_conflict,
      conflict_target: [:issuer_uid, :issuer],
      returning: true
    )
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

  #
  # Aggregate Reputation
  #

  def create_or_update_aggregate_reputation(attrs) do
    %AggregateReputation{}
    |> AggregateReputation.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace_all_except, [:id, :inserted_at]},
      conflict_target: [:issuer_uid, :issuer],
      returning: true
    )
  end

  def get_aggregate_reputation(eth_address) do
    AggregateReputation
    |> join(:inner, [ar], u in assoc(ar, :user), as: :u)
    |> where([u: u], u.eth_address == ^eth_address)
    |> select([ar, u: u], ar)
    |> Repo.all()
  end
end
