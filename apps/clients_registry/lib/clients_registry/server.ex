defmodule ClientsRegistry.Server do
  @moduledoc false

  use GenServer

  @registry_name Application.get_env(:clients_registry, :name)

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: @registry_name)
  end

  def handle_call({:take, pid_count}, _from, pids) do
    {taken_pids, remaining_pids} = Enum.split(pids, pid_count)
    {:reply, taken_pids, remaining_pids}
  end

  def handle_cast({:add, pid}, pids) do
    {:noreply, sort_pids([pid | pids])}
  end

  defp sort_pids(pids) do
    ordered_pids =
      pids
      |> Enum.map(&({&1, node(&1)}))
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
      |> Map.values()
      |> Enum.zip()
      |> Enum.flat_map(&Tuple.to_list/1)

    ordered_pids ++ pids -- ordered_pids
  end
end
