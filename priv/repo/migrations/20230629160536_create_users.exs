defmodule Explorer.Repo.Migrations.EnableCitext do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :eth_address, :citext, null: false
      add :reputable_seller_id, :string

      timestamps()
    end

    create unique_index(:users, [:eth_address])
    create unique_index(:users, [:reputable_seller_id])
  end
end
