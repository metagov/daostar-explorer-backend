defmodule Explorer.Activity.AggregateReputation do
  use Ecto.Schema

  import Ecto.Changeset

  @current_version "2-rc1"

  alias __MODULE__
  alias Explorer.Accounts.User

  schema "aggregate_reputation" do
    field :issuer, :string
    field :issuer_uid, :string
    field :issuer_uri, :string
    field :version, :string, default: @current_version
    field :score, :float
    field :expiration, :utc_datetime
    field :proof, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%AggregateReputation{} = aggregate_reputation, attrs) do
    aggregate_reputation
    |> cast(attrs, [
      :version,
      :issuer,
      :issuer_uid,
      :issuer_uri,
      :score,
      :proof,
      :expiration,
      :user_id
    ])
    |> validate_required([
      :issuer,
      :issuer_uid,
      :issuer_uri,
      :score,
      :user_id
    ])
    |> unique_constraint([:issuer_uid, :issuer])
  end
end
