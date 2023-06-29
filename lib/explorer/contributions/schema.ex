defmodule Explorer.Contributions.Schema do
  use Ecto.Schema

  import Ecto.Changeset

  @current_version "2-rc1"
  @default_category "Unknown"

  alias __MODULE__
  alias Explorer.Accounts.User

  schema "contributions" do
    field(:issuer, :string)
    field(:issuer_uid, :string)
    field(:issuer_uri, :string)
    field(:version, :string, default: @current_version)
    field(:title, :string)
    field(:description, :string)
    field(:category, :string, default: @default_category)
    field(:date_of_engagement, :utc_datetime)
    field(:contributors, {:array, :string}, default: [])
    field(:contributor_signatures, {:array, :string}, default: [])
    field(:metadata, :map)
    field(:metadata_uri, :string)

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(%Schema{} = schema, attrs) do
    schema
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
      :metadata_uri
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
      :contributor_signatures
    ])
    |> unique_constraint([:issuer_uid, :issuer])
  end
end
