defmodule Dispatcher.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Supervisor.start_link(
      [{Dispatcher.Server, nil}],
      [strategy: :one_for_one, name: Dispatcher.Supervisor]
    )
  end
end
