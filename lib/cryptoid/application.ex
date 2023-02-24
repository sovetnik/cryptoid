defmodule Cryptoid.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CryptoidWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Cryptoid.PubSub},
      # Start the Endpoint (http/https)
      CryptoidWeb.Endpoint,
      Cryptoid.System
      # Start a worker by calling: Cryptoid.Worker.start_link(arg)
      # {Cryptoid.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cryptoid.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CryptoidWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
