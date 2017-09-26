defmodule ProblemGroup do
  @type t :: [Problem.t | t]
  @type problem_position :: [Access.access_fun(data :: list, get_value :: term)]
  @type timeout_count :: non_neg_integer

  @spec collect_solution(t, pos_integer) :: {Problem.solution, timeout_count}
  def collect_solution(group, timeout_divider) do
    flat_group = List.flatten(group)
    collector = fn(%{data: %{profits: p_profits}, solution: p_sol}, {sol, p_offset}) ->
      {sol ++ Enum.map(p_sol, &(&1 + p_offset)), p_offset + length(p_profits)}
    end

    {
      flat_group |> List.foldl({[], 0}, collector) |> elem(0),
      div(length(flat_group) - length(group), timeout_divider - 1)
    }
  end

  @spec solved?(t) :: boolean
  def solved?(group) do
    group |> List.flatten() |> Enum.all?(&(&1.solution |> is_nil() |> Kernel.not))
  end

  @spec get_at(t, problem_position) :: Problem.t
  def get_at(group, problem_position) do
    get_in(group, problem_position)
  end

  @spec put_at(t, problem_position, Problem.t | [Problem.t]) :: t
  def put_at(group, problem_position, problem_or_problems) do
    put_in(group, problem_position, problem_or_problems)
  end
end
