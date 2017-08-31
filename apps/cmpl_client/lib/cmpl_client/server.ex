defmodule CmplClient.Server do
  @moduledoc """
  OTP server
  """

  use GenServer

  @group_name Application.get_env(:cmpl_client, :group_name)
  @dispatcher_name Application.get_env(:cmpl_client, :dispatcher_name)

  # Client

  @doc """
  Starts the server
  """
  @spec start_link(any) :: GenServer.on_start
  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @doc """
  Initializes client execution
  """
  @spec run(pid, CmplClient.data) :: :ok
  def run(pid, data) do
    GenServer.cast(pid, {:run, data})
  end

  # Server (callbacks)

  # Assigns to the given group
  def init(_args) do
    :ok = :pg2.join(@group_name, self())
    {:ok, nil}
  end

  # Calls the client
  def handle_cast({:run, data}, state) do
    solution = CmplClient.run(data)
    GenServer.cast(@dispatcher_name, {:solution, solution})
    {:noreply, state}
  end
end
