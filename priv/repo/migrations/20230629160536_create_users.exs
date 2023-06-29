defmodule Explorer.Repo.Migrations.EnableCitext do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :eth_address, :citext, null: false

      timestamps()
    end

    create unique_index(:users, [:eth_address])
  end
end
