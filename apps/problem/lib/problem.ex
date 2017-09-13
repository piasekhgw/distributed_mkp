defmodule Problem do
  alias Problem.{Data, CmplFile, SolutionFile}

  defstruct [:data, :solution]

  @type t :: %__MODULE__{data: Problem.Data.t, solution: solution}
  @type solution :: [non_neg_integer] | :timeout

  @spec solve!(t) :: t | no_return
  def solve!(%{data: data} = problem) do
    solution = data |> Data.write!() |> CmplFile.process!() |> SolutionFile.read!()

    %{problem | solution: solution}
  end

  @spec split(t, pos_integer) :: [t]
  def split(%{data: data}, divider) do
    data |> Data.split(divider) |> Enum.map(&%__MODULE__{data: &1})
  end

  @spec collect_solution([t]) :: solution
  def collect_solution(problems) do
    collector = fn(%{data: %{profits: p_profits}, solution: p_sol}, {sol, p_offset}) ->
      {sol ++ Enum.map(p_sol, &(&1 + p_offset)), p_offset + length(p_profits)}
    end

    problems |> List.foldl({[], 0}, collector) |> elem(0)
  end
end
