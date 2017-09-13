defmodule CmplClient.Application do
  @moduledoc false

  use Application

  @server_count Application.get_env(:cmpl_client, :server_count)

  def start(_type, _args) do
    1..@server_count
    |> Enum.map(&Supervisor.child_spec({CmplClient.Server, nil}, id: :"client_#{&1}"))
    |> Supervisor.start_link([strategy: :one_for_one, name: CmplClient.Supervisor])
  end
end
