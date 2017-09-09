defmodule Problem.CmplFile do
  @type t :: String.t

  @cmpl_timeout Application.get_env(:problem, :cmpl_timeout)

  @spec process!(t) :: Problem.SolutionFile.t | no_return
  def process!(problem_path) do
    solution_path = Temp.path!(%{suffix: ".csol"})

    System
    |> apply(:cmd, command_args(problem_path, solution_path))
    |> process_command_result(solution_path)
  end

  defp command_args(problem_path, solution_path) do
    [
      "timeout",
      [
        Integer.to_string(@cmpl_timeout),
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
