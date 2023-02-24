defmodule Cryptoid.Storage do
  @moduledoc "Counter module, which accepts stream"

  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
    IO.puts("Storage started")
  end

  def rates() do
    Agent.get(__MODULE__, & &1)
  end

  def update(rates) do
    Agent.update(__MODULE__, rates)
    IO.puts("New rates set")
  end
end
