defmodule CmplClient.ProblemSolver do
  @moduledoc false

  @executable_timeout Application.get_env(:cmpl_client, :executable_timeout)

  def solve(problem_path) do
    solution_path = Temp.path!(%{suffix: ".csol"})

    System
    |> apply(:cmd, command_args(problem_path, solution_path))
    |> process_command_result(solution_path)
  end

  defp command_args(problem_path, solution_path) do
    [
      "timeout",
      [
        Integer.to_string(@executable_timeout),
        "cmpl",
        problem_path,
        "-solution",
        solution_path,
        "-ignoreZeros"
      ]
    ]
  end

  defp process_command_result({_, 0}, solution_path), do: solution_path
  defp process_command_result({_, 124}, _), do: :timeout
end
