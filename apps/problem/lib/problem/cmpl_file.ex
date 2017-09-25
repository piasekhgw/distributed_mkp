defmodule Problem.CmplFile do
  alias Problem.SolutionFile

  @type t :: String.t
  @type executable_timeout :: non_neg_integer

  @spec process!(t, executable_timeout) :: SolutionFile.t | no_return
  def process!(problem_path, executable_timeout) do
    solution_path = Temp.path!(%{suffix: ".csol"})

    System
    |> apply(:cmd, command_args(problem_path, solution_path, executable_timeout))
    |> process_command_result(solution_path)
  end

  defp command_args(problem_path, solution_path, executable_timeout) do
    [
      "timeout",
      [
        Integer.to_string(executable_timeout),
        "cmpl",
        problem_path,
        "-solution",
        solution_path,
        "-ignoreZeros"
      ]
    ]
  end

  defp process_command_result({_, 0}, solution_path), do: solution_path
  defp process_command_result({_, 124}, _), do: :enoent
end
