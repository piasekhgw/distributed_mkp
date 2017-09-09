defmodule Problem.SolutionFile do
  import SweetXml

  @type t :: String.t | :enoent

  @spec read!(t) :: :timeout when t: :enoent | [non_neg_integer] | no_return
  def read!(:enoent) do
    :timeout
  end

  def read!(solution_path) do
    solution_path
    |> File.stream!
    |> xpath(~x"//variable/@name"sl)
    |> Enum.map(&(~r/\d+/ |> Regex.run(&1) |> hd() |> String.to_integer()))
  end
end
