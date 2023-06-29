defmodule Explorer.Storage do
  def normalize(nil), do: {:error, :not_found}
  def normalize(term), do: {:ok, term}
end
