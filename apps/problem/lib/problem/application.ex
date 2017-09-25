defmodule Problem.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    set_env()
    children = [Supervisor.child_spec(Problem.Worker, [restart: :transient])]
    opts = [strategy: :simple_one_for_one, name: Application.get_env(:problem, :supervisor_name)]
    Supervisor.start_link(children, opts)
  end

  defp set_env do
    executable_timeout = "CMPL_EXECUTABLE_TIMEOUT" |> System.get_env() |> String.to_integer()
    Application.put_env(:problem, :executable_timeout, executable_timeout)
  end
end
