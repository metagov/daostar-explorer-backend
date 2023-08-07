defmodule Explorer.Repo.Migrations.CreateAttestationIssuers do
  use Ecto.Migration

  def change do
    create table(:attestation_issuers) do
      add :dao_id, references(:daos), null: false
      add :issuer_uri, :string, null: false

      timestamps()
    end
  end
end
