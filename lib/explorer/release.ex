defmodule Explorer.Release do
  @app :explorer

  def migrate do
    for repo <- repos() do
      {:ok, _, _} =
        Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} =
      Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seed do
    Application.load(@app)

    {:ok, _, _} =
      Ecto.Migrator.with_repo(HelloMigrations.Repo, fn _repo ->
        Code.eval_file("priv/repo/seeds.exs")
      end)
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
