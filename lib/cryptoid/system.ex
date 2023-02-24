defmodule Cryptoid.System do
  @moduledoc """
  Supervisor for Cache
  """

  alias Cryptoid.{Scheduler, Storage}

  def start_link() do
    start_link(0, 0)
  end

  def start_link(_type, _args) do
    children = [
      # {Storage, %{}},
      # {Scheduler, 0}
    ]

    opts = [
      strategy: :one_for_one,
      name: __MODULE__
    ]

    Supervisor.start_link(children, opts)
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end
end
