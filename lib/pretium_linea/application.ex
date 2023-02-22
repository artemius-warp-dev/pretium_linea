defmodule PretiumLinea.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PretiumLineaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PretiumLinea.PubSub},
      # Start the Endpoint (http/https)
      PretiumLineaWeb.Endpoint,
      {PretiumLinea.BA.Server, []},
      {PretiumLinea.AFKLM.Server, []},
      {Task.Supervisor, [name: PretiumLinea.TaskSupervisor, max_restarts: 3]}
      # Start a worker by calling: PretiumLinea.Worker.start_link(arg)
      # {PretiumLinea.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PretiumLinea.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PretiumLineaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
