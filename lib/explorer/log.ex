defmodule Explorer.Log do
  require Logger

  def error(mod, error) do
    log(mod, :error, error)
  end

  def info(mod, info) do
    log(mod, :info, info)
  end

  def debug(mod, error) do
    log(mod, :debug, error)
  end

  defp log(mod, level, error) do
    arg = fn -> format_message(mod, error) end
    apply(Logger, level, [arg])
  end

  defp format_message(mod, error) do
    "[#{mod}]: #{inspect(error)}"
  end
end
