defmodule Explorer.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__
  alias Explorer.Activity.Contribution

  schema "users" do
    field(:eth_address, :string)

    has_many(:contributions, Contribution)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:eth_address])
    |> validate_required([:eth_address])
    |> unique_constraint(:eth_address, downcase: true)
  end
end
