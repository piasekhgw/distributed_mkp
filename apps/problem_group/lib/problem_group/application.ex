defmodule ProblemGroup.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    set_env()
    children = [{ProblemGroup.Worker, nil}]
    opts = [strategy: :one_for_one, name: ProblemGroup.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp set_env do
    problem_nodes = "PROBLEM_NODES" |> System.get_env() |> String.split(",") |> Enum.map(&String.to_atom/1)
    Application.put_env(:problem_group, :problem_nodes, problem_nodes)

    call_timeout = "PROBLEM_GROUP_CALL_TIMEOUT" |> System.get_env() |> String.to_integer()
    Application.put_env(:problem_group, :call_timeout, call_timeout)

    dividers = [
      initial: "PROBLEM_GROUP_INITIAL_DIVIDER" |> System.get_env() |> String.to_integer(),
      timeout: "PROBLEM_GROUP_TIMEOUT_DIVIDER" |> System.get_env() |> String.to_integer()
    ]
    Application.put_env(:problem_group, :dividers, dividers)
  end
end
