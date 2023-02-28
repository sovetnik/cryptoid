defmodule Cryptoid.Scheduler do
  use GenServer
  require Logger

  alias Cryptoid.{Rates, Storage}
  alias Phoenix.PubSub

  @timeout 60_000

  def start_link(count) do
    Logger.notice("Scheduler started: " <> inspect(NaiveDateTime.local_now()))

    GenServer.start_link(__MODULE__, count, name: __MODULE__)
  end

  def init(count) do
    Logger.notice("Scheduler initialized: " <> to_string(count))
    {:ok, count, @timeout}
  end

  def handle_info(:timeout, state) do
    Logger.notice("Getting new rates: " <> to_string(state) <> inspect(NaiveDateTime.local_now()))

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
