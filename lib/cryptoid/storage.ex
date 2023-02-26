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
    |> IO.inspect(label: "Storage started: " <> inspect(NaiveDateTime.local_now()))
  end

  def currencies do
    Agent.get(__MODULE__, &Map.keys(&1))
  end

  def rate(currency) do
    %Rate{
      name: currency,
      price: Agent.get(__MODULE__, & &1[currency])
    }
  end

  def update(rates) do
    Agent.update(
      __MODULE__,
      fn _state -> rates end
    )
    |> IO.inspect(label: "New rates set: " <> inspect(NaiveDateTime.local_now()))
  end
end
