defmodule Cryptoid.Scheduler do
  use GenServer

  alias Cryptoid.{Rates, Storage}

  @timeout 60_000

  def start_link(count) do
    count |> IO.inspect(label: :sl_process)

    GenServer.start_link(__MODULE__, count, name: __MODULE__)
    |> IO.inspect(label: "Scheduler started")
  end

  def init(count) do
    count
    |> IO.inspect(label: :pocess_init)

    {:ok, count, @timeout}
  end

  def handle_info(:timeout, state) do
    IO.puts("timeout reached for #{state}")
    rates = Task.async(&Rates.get/0)

    rates |> Task.await() |> Storage.update()

    {:noreply, state + 1, @timeout}
  end
end
