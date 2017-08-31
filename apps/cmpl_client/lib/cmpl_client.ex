defmodule CmplClient do
  @moduledoc """
  Cmpl client
  """

  alias CmplClient.{ProblemSolver, ProblemWriter, SolutionReader}

  @type data :: %{
    items: [integer],
    resources: [integer],
    profits: [integer],
    capacities: [integer],
    costs: [[integer]]
  }
  @type solution :: [integer]

  @doc """
  Runs cmpl executable and returns a solution
  """
  @spec run(data) :: solution
  def run(data) do
    data
    |> ProblemWriter.write()
    |> ProblemSolver.solve()
    |> SolutionReader.read()
  end
end
