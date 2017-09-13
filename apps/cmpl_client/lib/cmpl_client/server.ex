defmodule CmplClient.Server do
  @moduledoc false

  use GenServer

  @clients_registry_name Application.get_env(:clients_registry, :name)
  @dispatcher_name Application.get_env(:dispatcher, :name)

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_args) do
    add_to_registry()
    {:ok, nil}
  end

  def handle_cast({:run, problem, problem_position}, state) do
    problem |> Problem.solve!() |> reply_to_dispatcher(problem_position)
    add_to_registry()

    {:noreply, state}
  end

  defp add_to_registry do
    GenServer.cast(@clients_registry_name, {:add, self()})
  end

  defp reply_to_dispatcher(problem, problem_position) do
    GenServer.cast(@dispatcher_name, {:client_response, problem, problem_position})
  end
end
