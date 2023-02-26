defmodule Cryptoid.Rates do
  @moduledoc "Rates parser"
  @path '/v1/cryptocurrency/listings/latest'

  alias Cryptoid.Request

  def get do
    @path
    |> Request.get()
    |> parse()
    |> Map.new()
  end

  def parse(%{"data" => data}) do
    data |> Enum.map(fn element -> parse(element) end)
  end

  def parse(%{
        "name" => name,
        "quote" => %{
          "USD" => %{"price" => price}
        }
      }) do
    {name, price}
  end
end
