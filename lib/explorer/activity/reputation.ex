defmodule Explorer.Activity.Reputation do
  use Ecto.Schema

  import Ecto.Changeset

  @current_version "2-rc1"

  alias __MODULE__
  alias Explorer.Accounts.User

  schema "reputations" do
    field :issuer, :string
    field :issuer_uid, :string
    field :issuer_uri, :string
    field :version, :string, default: @current_version
    field :proof, :string
    field :score, :string
    field :date_of_expiration, :utc_datetime
    field :date_of_rating, :utc_datetime

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Reputation{} = contribution, attrs) do
    contribution
    |> cast(attrs, [
      :version,
      :issuer,
      :issuer_uid,
      :issuer_uri,
      :proof,
      :score,
      :date_of_rating,
      :date_of_expiration
    ])
    |> validate_required([
      :issuer,
      :issuer_uid,
      :issuer_uri,
      :score,
      :date_of_rating
    ])
    |> unique_constraint([:issuer_uid, :issuer])
  end
end
