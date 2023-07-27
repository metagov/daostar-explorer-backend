defmodule Explorer.Accounts do
  import Explorer.Storage

  alias Explorer.Accounts.User
  alias Explorer.Repo

  def get_user(eth_address) do
    Repo.get_by(User, eth_address: eth_address)
    |> normalize()
  end

  def get_or_create_user(eth_address) do
    case get_user(eth_address) do
      {:ok, user} -> {:ok, user}
      {:error, :not_found} -> create_user(%{eth_address: eth_address})
    end
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_or_update_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, Map.keys(attrs)},
      conflict_target: [:eth_address]
    )
  end
end
