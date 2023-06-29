defmodule Explorer.Utils.Enum do
  @moduledoc """
  Collection of Enum utilities.

  As a general rule of thumb, to avoid ambiguity, don't do `import
  Explorer.Utils.Enum` or `alias Explorer.Utils.Enum`. Instead prefer being
  explicit by doing `alias Explorer.Utils` and using as
  `Utils.Enum.reduce_results/1` (or other functions).
  """

  @doc """
  Reduces the enum while the values are in the format `{:ok, term()}`. Halts
  once `{:error, term()}` is found.

  If all results are an `:ok` tuple, return value is `{:ok, [term()]}` where
  the second element are all of the results. Otherwise, returns
  `{:error, term()}` where the second element is the reason for the error.
  """
  def reduce_results(results) do
    Enum.reduce_while(results, {:ok, []}, fn
      {:ok, value}, {:ok, acc} -> {:cont, {:ok, append(acc, value)}}
      {:error, _} = result, _ -> {:halt, result}
    end)
  end

  @doc """
  Executes the given function in an enum and reduces the results using
  `Explorer.Utils.Enum.reduce_results/1`.
  """
  def batch_operation(enum, op) do
    enum
    |> Stream.map(&op.(&1))
    |> reduce_results()
  end

  @doc """
  Applies a function to every element of the enum. It then applies
  `Enum.reject/2` using the given `reject` function, defaulting to `is_nil/1`.

  Essentially this function allows to apply `mapper` to every element, ignoring
  those whose result is `nil`.
  """
  def map_reject(enum, mapper, reject \\ &is_nil/1) do
    Stream.map(enum, mapper)
    |> Enum.reject(reject)
  end

  @doc """
  Appends an element to the end of a list. It's equivalent to `list ++ [elem]`
  but users a combination of `Enum.reverse/1` and prepending, which is more
  performant.
  """
  def append(list, elem) do
    Enum.reverse([elem | Enum.reverse(list)])
  end
end
