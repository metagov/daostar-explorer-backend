defmodule Explorer.Repo.Migrations.CreateContributions do
  use Ecto.Migration

  def change do
    create table(:contributions) do
      add :issuer, :string, null: false
      add :issuer_uid, :string
      add :issuer_uri, :string, null: false
      add :version, :string, null: false
      add :title, :string, null: false
      add :description, :text
      add :category, :string, null: false
      add :proof, :string
      add :metadata, :jsonb
      add :metadata_uri, :string
      add :external, :jsonb
      add :date_of_engagement, :utc_datetime
      add :contributors, {:array, :string}, default: []
      add :contributor_signatures, {:array, :string}, default: []
      add :tx_hash, :citext
      add :status, :string, null: false

      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:contributions, [:issuer_uid, :issuer])
  end
end
