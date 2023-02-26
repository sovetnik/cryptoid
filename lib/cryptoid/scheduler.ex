defmodule Cryptoid.Scheduler do
  use GenServer

  alias Cryptoid.{Rates, Storage}
  alias Phoenix.PubSub

  @timeout 60_000

  def start_link(count) do
    count |> IO.inspect(label: :sl_process)

    GenServer.start_link(__MODULE__, count, name: __MODULE__)
    |> IO.inspect(label: "Scheduler started: " <> inspect(NaiveDateTime.local_now()))
  end

  def init(count) do
    count
    |> IO.inspect(label: :pocess_init)

    {:ok, count, @timeout}
  end

  def handle_info(:timeout, state) do
    IO.puts("timeout reached for #{state}")

    Rates
    |> Function.capture(:get, 0)
    |> Task.async()
    |> Task.await()
    |> Storage.update()

    PubSub.broadcast(
      Cryptoid.PubSub,
      "rates",
      :rates_updated
    )

    {:noreply, state + 1, @timeout}
  end
end
