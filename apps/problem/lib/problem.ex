defmodule Problem do
  alias Problem.{Data, CmplFile, SolutionFile}

  defstruct [:data, :solution]

  @type t :: %__MODULE__{data: Data.t, solution: solution}
  @type solution :: [non_neg_integer] | :timeout

  @spec new(Data.profits, Data.capacities, Data.costs) :: t
  def new(profits, capacities, costs) do
    %__MODULE__{data: Data.new(profits, capacities, costs)}
  end

  @spec solve!(t, CmplFile.executable_timeout) :: t | no_return
  def solve!(%{data: data} = problem, executable_timeout) do
    solution =
      data
      |> Data.write!()
      |> CmplFile.process!(executable_timeout)
      |> SolutionFile.read!()

    %{problem | solution: solution}
  end

  @spec split(t, pos_integer) :: [t]
  def split(%{data: data}, divider) do
    data |> Data.split(divider) |> Enum.map(&%__MODULE__{data: &1})
  end

  @spec calculate_profit(t) :: non_neg_integer
  def calculate_profit(%{data: data, solution: solution}) do
    data.profits
    |> Enum.with_index()
    |> Enum.filter(fn({_profit, idx}) -> Enum.member?(solution, idx) end)
    |> List.foldl(0, fn({profit, _idx}, total_profit) -> total_profit + profit end)
  end

  @spec valid?(t) :: boolean
  def valid?(%{solution: nil}) do
    false
  end

  def valid?(%{data: data, solution: solution}) do
    data.costs
    |> Enum.map(&calculate_resource_usage(&1, solution))
    |> Enum.zip(data.capacities)
    |> Enum.all?(fn({usage, capacity}) -> usage <= capacity end)
  end

  defp calculate_resource_usage(resource_costs, solution) do
    resource_costs
    |> Enum.with_index()
    |> Enum.filter(&Enum.member?(solution, elem(&1, 1)))
    |> List.foldl(0, &(&2 + elem(&1, 0)))
  end
end
