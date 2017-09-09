defmodule Problem.Data do
  require EEx

  defstruct [:profits, :capacities, :costs]

  @type t :: %__MODULE__{
    profits: [pos_integer],
    capacities: [pos_integer],
    costs: [[pos_integer]]
  }

  @template_path Application.get_env(:problem, :template_path)
  @template_args [:items, :resources, :profits, :capacities, :costs]

  EEx.function_from_file(:defp, :problem_template, @template_path, @template_args)

  @spec write!(t) :: Problem.CmplFile.t | no_return
  def write!(data) do
    problem_path = Temp.path!(%{suffix: ".cmpl"})
    formatted_args = Enum.map(@template_args, &(data |> template_val(&1) |> format_val()))
    File.write!(problem_path, apply(&problem_template/5, formatted_args))

    problem_path
  end

  @spec split(t, pos_integer) :: [t]
  def split(data, divider) do
    data
    |> Map.from_struct()
    |> Map.keys()
    |> Enum.map(&split_key(&1, Map.fetch!(data, &1), divider))
    |> Enum.zip()
    |> Enum.map(&%__MODULE__{capacities: elem(&1, 0), costs: elem(&1, 1), profits: elem(&1, 2)})
  end

  defp template_val(data, :items), do: data.profits |> Enum.with_index() |> Keyword.values()
  defp template_val(data, :resources), do: data.capacities |> Enum.with_index() |> Keyword.values()
  defp template_val(data, arg), do: Map.fetch!(data, arg)

  defp format_val(v) when is_list(v), do: "(#{v |> Enum.map(&format_val/1) |> Enum.join(",")})"
  defp format_val(v), do: v

  defp split_key(:profits, data, divider) do
    chunk_enumerable(data, divider)
  end

  defp split_key(:capacities, data, divider) do
    data
    |> Enum.map(fn(c) -> 1..c |> chunk_enumerable(divider) |> Enum.map(&Enum.count/1) end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp split_key(:costs, data, divider) do
    data
    |> Enum.map(&chunk_enumerable(&1, divider))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp chunk_enumerable(e, divider) do
    Enum.chunk_every(e,  Enum.count(e) / divider |> Float.ceil() |> round())
  end
end
