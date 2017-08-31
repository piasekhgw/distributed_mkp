defmodule Dispatcher.Application do
  @moduledoc false

  use Application

  @worker_present Application.get_env(:dispatcher, :worker_present)

  def start(_type, _args) do
    children = List.duplicate(Dispatcher.Server, (if @worker_present, do: 1, else: 0))
    opts = [strategy: :one_for_one, name: Dispatcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
