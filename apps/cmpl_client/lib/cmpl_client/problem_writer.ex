defmodule CmplClient.ProblemWriter do
  @moduledoc false

  require EEx

  @template_path Application.get_env(:cmpl_client, :problem_template_path)

  EEx.function_from_file(:defp, :problem_template, @template_path, [:data])

  def write(data) do
    problem_path = Temp.path!(%{suffix: ".cmpl"})
    formatted_data = data |> Enum.map(fn({k, v}) -> {k, format_val(v)} end) |> Map.new()
    File.write!(problem_path, problem_template(formatted_data))

    problem_path
  end

  defp format_val(v) when is_list(v), do: "(#{v |> Enum.map(&format_val/1) |> Enum.join(",")})"
  defp format_val(v), do: v
end
