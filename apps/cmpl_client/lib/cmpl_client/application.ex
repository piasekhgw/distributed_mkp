defmodule CmplClient.Application do
  @moduledoc false

  use Application

  @group_name Application.get_env(:cmpl_client, :group_name)
  @worker_count Application.get_env(:cmpl_client, :worker_count)

  def start(_type, _args) do
    :pg2.create(@group_name)
    children = Enum.map(
      1..@worker_count,
      &Supervisor.child_spec({CmplClient.Server, nil}, id: :"cmpl_client_#{&1}")
    )
    opts = [strategy: :one_for_one, name: CmplClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
