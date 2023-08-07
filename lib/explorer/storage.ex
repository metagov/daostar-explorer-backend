defmodule Explorer.Storage do
  alias Explorer.Repo

  import Ecto.Query, only: [preload: 2]

  def normalize(nil), do: {:error, :not_found}
  def normalize(term), do: {:ok, term}

  def include(%Ecto.Query{} = scope, opts) do
    preload = opts[:preload] || []

    preload(scope, ^preload)
  end

  def include(%{__meta__: _} = schema, opts) do
    preload = opts[:preload] || []

    Repo.preload(schema, preload)
  end
end
