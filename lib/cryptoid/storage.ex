defmodule Cryptoid.Storage do
  @moduledoc "Counter module, which accepts stream"

  use Agent
  require Logger

  alias Cryptoid.Rates
  alias Cryptoid.Rates.Rate

  def start_link(_initial_value) do
    Logger.notice("Storage started: " <> inspect(NaiveDateTime.local_now()))

    Agent.start_link(
      fn -> Rates.get() end,
      name: __MODULE__
    )
  end

  def currencies do
    Agent.get(__MODULE__, &Map.keys/1)
  end

  def rate(currency) do
    %Rate{
      name: currency,
      price: Agent.get(__MODULE__, & &1[currency])
    }
  end

  def update(rates) do
    Logger.notice("Storing new rates: " <> inspect(NaiveDateTime.local_now()))

    Agent.update(
      __MODULE__,
      fn _state -> rates end
    )
  end
end
