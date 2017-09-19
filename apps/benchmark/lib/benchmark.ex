defmodule Benchmark do
  @moduledoc false

  def run(input_file_path) do
    [problem_count | problems] = read_data(input_file_path)
    best_solution_vals = read_data("#{input_file_path}_best")

    problems
    |> Enum.chunk_every(problems |> length |> div(problem_count))
    |> Enum.map(&get_solution_info/1)
    |> Enum.zip(best_solution_vals)
    |> Enum.each(&print_output_values/1)
  end

  defp read_data(file_path) do
    file_path
    |> File.read!()
    |> String.split(~r{\s+}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp get_solution_info(problem_data) do
    {[items, resources, _val], remaining_data} = Enum.split(problem_data, 3)
    {profits, remaining_data} = Enum.split(remaining_data, items)
    {flat_costs, capacities} = Enum.split(remaining_data, items * resources)
    costs = Enum.chunk_every(flat_costs, items)

    problem = %Problem{data: %Problem.Data{profits: profits, costs: costs, capacities: capacities}}
    {time, {solution, timeout_count}} = :timer.tc(fn -> Dispatcher.Server.run(problem) end)
    solved_problem = %{problem | solution: solution}

    unless Problem.solution_valid?(solved_problem), do: raise "solution invalid"

    IO.write(".")

    {Problem.calculate_profit(solved_problem), timeout_count, Float.round(time / 1_000_000, 1)}
  end

  defp print_output_values({{sol_val, timeout_count, time}, best_sol_val}) do
    IO.puts("")
    Enum.each(
      [sol_val, best_sol_val, round(sol_val / best_sol_val * 100), timeout_count, time],
      &IO.inspect/1
    )
  end
end
