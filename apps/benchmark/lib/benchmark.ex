defmodule Benchmark do
  @moduledoc false

  def run(input_file_path) do
    [problem_count | problems] = read_data(input_file_path)
    best_solution_vals = read_data("#{input_file_path}_best")

    problems
    |> Enum.chunk_every(problems |> length |> div(problem_count))
    |> Enum.map(&get_solution_metrics/1)
    |> Enum.zip(best_solution_vals)
    |> Enum.each(&print_output/1)
  end

  defp read_data(file_path) do
    file_path
    |> File.read!()
    |> String.split(~r{\s+}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp get_solution_metrics(raw_problem_data) do
    {profits, capacities, costs} = parse_problem_data(raw_problem_data)
    problem = Problem.new(profits, capacities, costs)
    {time, {solution, timeout_count}} = :timer.tc(fn -> ProblemGroup.Worker.solve([problem]) end)
    solved_problem = %{problem | solution: solution}
    unless Problem.valid?(solved_problem), do: raise "solution invalid"
    IO.write(".")

    {Problem.calculate_profit(solved_problem), timeout_count, Float.round(time / 1_000_000, 1)}
  end

  defp parse_problem_data(raw_problem_data) do
    {[items, resources, _val], remaining_data} = Enum.split(raw_problem_data, 3)
    {profits, remaining_data} = Enum.split(remaining_data, items)
    {flat_costs, capacities} = Enum.split(remaining_data, items * resources)
    costs = Enum.chunk_every(flat_costs, items)

    {profits, capacities, costs}
  end

  defp print_output({{sol_val, timeout_count, time}, best_sol_val}) do
    IO.puts("")
    Enum.each(
      [sol_val, best_sol_val, round(sol_val / best_sol_val * 100), timeout_count, time],
      &IO.inspect/1
    )
  end
end
