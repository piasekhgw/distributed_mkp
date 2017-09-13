defmodule ClientsRegistry.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Supervisor.start_link(
      [ClientsRegistry.Server],
      [strategy: :one_for_one, name: ClientsRegistry.Supervisor]
    )
  end
end
