defmodule Explorer.Repo.Migrations.CreateDAOs do
  use Ecto.Migration

  def change do
    create table(:daos) do
      add :slug, :citext, null: false
      add :name, :citext, null: false
      add :description, :text

      timestamps()
    end

    create unique_index(:daos, [:slug])
  end
end
