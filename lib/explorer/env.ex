defmodule Explorer.Env do
  @otp_app :explorer

  def load(key) do
    Application.get_env(@otp_app, key)
    |> parse_env()
  end

  def load(mod, keys) when is_list(keys) do
    Application.get_env(@otp_app, mod)
    |> get_in(keys)
    |> parse_env()
  end

  def load(mod, key) do
    Application.get_env(@otp_app, mod)
    |> get_in([key])
    |> parse_env()
  end

  defp parse_env({:system, var}), do: System.get_env(var)
  defp parse_env({m, f, a}), do: apply(m, f, a)
  defp parse_env(value), do: value
end
