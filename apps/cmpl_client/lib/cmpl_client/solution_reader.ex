defmodule CmplClient.SolutionReader do
  @moduledoc false

  import SweetXml

  def read(:timeout) do
    :timeout
  end

  def read(xml_solution_path) do
    xml_solution_path
    |> File.stream!
    |> xpath(~x"//variable/@name"sl)
    |> Enum.map(&(~r/\d+/ |> Regex.run(&1) |> hd() |> String.to_integer()))
  end
end
