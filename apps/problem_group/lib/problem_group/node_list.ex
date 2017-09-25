defmodule ProblemGroup.NodeList do
  @type t :: [node]

  @problem_supervisor_name Application.get_env(:problem, :supervisor_name)

  @spec dispatch_problems(t, [Problem.t], ProblemGroup.problem_position) :: :ok
  def dispatch_problems(nodes, problems, parent_position) do
    problems
    |> Enum.with_index()
    |> Enum.map(fn({p, i}) -> {p, parent_position ++ [Access.at(i)], Enum.at(nodes, rem(i, length(nodes)))} end)
    |> Enum.each(&run_problem/1)
  end

  defp run_problem({problem, problem_position, node}) do
    {:ok, worker_pid} = Supervisor.start_child({@problem_supervisor_name, node}, [])
    GenServer.cast(worker_pid, {:solve, problem, problem_position, self()})
  end
end
