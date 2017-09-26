defmodule ProblemGroup.Worker do
  use GenServer

  alias ProblemGroup.NodeList

  @worker_name Application.get_env(:problem_group, :worker_name)

  @doc false
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: @worker_name)
  end

  @spec solve(ProblemGroup.t) :: {Problem.solution, ProblemGroup.timeout_count}
  def solve(group) do
    GenServer.call(@worker_name, {:solve, group}, get_call_timeout())
  end

  @impl true
  def handle_call({:solve, group}, from, _state) do
    split_problem(group, [Access.at(0)], get_divider(:initial), from)
  end

  @impl true
  def handle_cast({:problem_solved, problem, problem_position}, state) do
    handle_problem_solution(problem, problem_position, state)
  end

  defp handle_problem_solution(%{solution: :timeout}, problem_position, {group, from}) do
    split_problem(group, problem_position, get_divider(:timeout), from)
  end

  defp handle_problem_solution(problem, problem_position, {group, from}) do
    new_group = ProblemGroup.put_at(group, problem_position, problem)

    case ProblemGroup.solved?(new_group) do
      true ->
        GenServer.reply(from, ProblemGroup.collect_solution(new_group, get_divider(:timeout)))
        {:noreply, nil}
      false ->
        {:noreply, {new_group, from}}
    end
  end

  defp split_problem(group, problem_position, divider, from) do
    new_problems = group |> ProblemGroup.get_at(problem_position) |> Problem.split(divider)
    NodeList.dispatch_problems(get_problem_nodes(), new_problems, problem_position)

    {:noreply, {ProblemGroup.put_at(group, problem_position, new_problems), from}}
  end

  defp get_call_timeout do
    Application.get_env(:problem_group, :call_timeout)
  end

  defp get_divider(divider_type) do
    Application.get_env(:problem_group, :dividers)[divider_type]
  end

  defp get_problem_nodes do
    Application.get_env(:problem_group, :problem_nodes)
  end
end
