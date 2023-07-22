defmodule Explorer.Activity.Contribution do
  use Ecto.Schema

  import Ecto.Changeset

  @current_version "2-rc1"
  @default_category "Unknown"
  @statuses ~w(imported unminted minting minted)a

  alias __MODULE__
  alias Explorer.Accounts.User

  schema "contributions" do
    field :issuer, :string
    field :issuer_uid, :string
    field :issuer_uri, :string
    field :version, :string, default: @current_version
    field :title, :string
    field :description, :string
    field :category, :string, default: @default_category
    field :date_of_engagement, :utc_datetime
    field :contributors, {:array, :string}, default: []
    field :contributor_signatures, {:array, :string}, default: []
    field :metadata, :map
    field :metadata_uri, :string
    field :external, :map, default: %{}
    field :tx_hash, :string

    field :status, Ecto.Enum, values: @statuses

    belongs_to :user, User

    timestamps()
  end

  def statuses, do: @statuses

  @doc false
  def changeset(%Contribution{} = contribution, attrs) do
    contribution
    |> cast(attrs, [
      :version,
      :issuer,
      :issuer_uid,
      :issuer_uri,
      :title,
      :description,
      :category,
      :date_of_engagement,
      :contributors,
      :contributor_signatures,
      :metadata,
      :metadata_uri,
      :external,
      :user_id,
      :status,
      :tx_hash
    ])
    |> validate_required([
      :issuer,
      :issuer_uid,
      :issuer_uri,
      :title,
      :metadata,
      :metadata_uri,
      :category,
      :version,
      :contributors,
      :contributor_signatures,
      :user_id,
      :status
    ])
    |> unique_constraint([:issuer_uid, :issuer])
  end

  @doc false
  def unminted_changeset(%Contribution{} = contribution, attrs) do
    contribution
    |> cast(attrs, [
      :version,
      :issuer,
      :issuer_uid,
      :issuer_uri,
      :title,
      :description,
      :category,
      :date_of_engagement,
      :contributors,
      :contributor_signatures,
      :metadata,
      :metadata_uri,
      :external,
      :user_id,
      :tx_hash
    ])
    |> validate_required([
      :issuer,
      :title,
      :category,
      :version,
      :contributors,
      :contributor_signatures,
      :user_id
    ])
    |> put_change(:status, :unminted)
  end

  @doc false
  def update_changeset(%Contribution{} = contribution, attrs) do
    contribution
    |> cast(attrs, [
      :issuer_uid,
      :status,
      :tx_hash
    ])
    |> unique_constraint([:issuer_uid, :issuer])
  end
end
