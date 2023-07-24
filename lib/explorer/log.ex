defmodule Explorer.Log do
  require Logger

  defmacrop log(mod, level, error) do
    quote do
      arg = fn -> format_message(unquote(mod), unquote(error)) end
      Logger.unquote(level)(arg)
    end
  end

  def error(mod, error) do
    log(mod, :error, error)
  end

  def info(mod, info) do
    log(mod, :info, info)
  end

  def debug(mod, error) do
    log(mod, :debug, error)
  end

  defp format_message(mod, error) do
    "[#{mod}]: #{inspect(error)}"
  end
end
