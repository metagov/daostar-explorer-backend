defmodule Explorer.Repo.Migrations.CreateAggregateReputation do
  use Ecto.Migration

  def change do
    create table(:aggregate_reputation) do
      add :issuer, :string, null: false
      add :issuer_uid, :string
      add :issuer_uri, :string, null: false
      add :version, :string, null: false
      add :proof, :string
      add :score, :float, null: false
      add :expiration, :utc_datetime

      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:aggregate_reputation, [:issuer_uid, :issuer])
  end
end
