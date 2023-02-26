defmodule Cryptoid.Storage do
  @moduledoc "Counter module, which accepts stream"

  use Agent

  alias Cryptoid.Rates
  alias Cryptoid.Rates.Rate

  def start_link(_initial_value) do
    Agent.start_link(
      fn -> Rates.get() end,
      name: __MODULE__
    )
    |> IO.inspect(label: "Storage started")
  end

  def currencies do
    Map.keys(rates())
  end

  def rate(currency) do
    %Rate{
      name: currency,
      price: rates()[currency]
    }
  end

  def rates() do
    Agent.get(__MODULE__, & &1)
  end

  def update(rates) do
    Agent.update(
      __MODULE__,
      fn _state -> rates end
    )
    |> IO.inspect(label: "New rates set")
  end
end
