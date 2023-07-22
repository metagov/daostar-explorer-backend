defmodule ExplorerWeb.Plug.CORS do
  def origin do
    Explorer.Env.load(__MODULE__, :origins)
    |> String.split(",")
    |> Enum.map(&Regex.compile!/1)
  end
end
