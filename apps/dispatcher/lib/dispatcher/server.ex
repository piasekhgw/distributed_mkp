defmodule Dispatcher.Server do
  @moduledoc false

  use GenServer

  @dispatcher_name Application.get_env(:dispatcher, :name)
  @clients_registry_name Application.get_env(:clients_registry, :name)
  @call_timeout Application.get_env(:dispatcher, :call_timeout)
  @dividers Application.get_env(:dispatcher, :dividers)

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: @dispatcher_name)
  end

  def run(problem) do
    GenServer.call(@dispatcher_name, {:run, problem}, @call_timeout)
  end

  def handle_call({:run, problem}, from, _state) do
    new_problems = Problem.split(problem, @dividers.initial)
    run_clients(new_problems, [Access.elem(0)])

    {:noreply, {new_problems, from}}
  end

  def handle_cast({:client_response, problem, problem_position}, state) do
    handle_client_response(problem, problem_position, state)
  end

  defp handle_client_response(%{solution: :timeout}, problem_position, state) do
    new_problems = state |> get_in(problem_position) |> Problem.split(@dividers.timeout)
    run_clients(new_problems, problem_position)

    {:noreply, put_in(state, problem_position, new_problems)}
  end

  defp handle_client_response(problem, problem_position, state) do
    {problems, from} = new_state = put_in(state, problem_position, problem)
    flat_problems = List.flatten(problems)

    case all_problems_resolved?(flat_problems) do
      true ->
        GenServer.reply(from, Problem.collect_solution(flat_problems, @dividers.initial, @dividers.timeout))
        {:noreply, nil}
      false ->
        {:noreply, new_state}
    end
  end

  defp run_clients(problems, position_offset) do
    [problems |> length() |> take_clients(), problems]
    |> Enum.zip()
    |> Enum.with_index()
    |> Enum.each(fn({{pid, p}, i}) -> run_client(pid, p, position_offset ++ [Access.at(i)]) end)
  end

  defp run_client(pid, problem, problem_position) do
    GenServer.cast(pid, {:run, problem, problem_position})
  end

  defp take_clients(client_count) do
    GenServer.call(@clients_registry_name, {:take, client_count})
  end

  defp all_problems_resolved?(problems) do
    Enum.all?(problems, &(&1.solution |> is_nil() |> Kernel.not))
  end
end
