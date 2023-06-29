defmodule Explorer.Result do
  def error?({:error, _}), do: true
  def error?(_), do: false
end
