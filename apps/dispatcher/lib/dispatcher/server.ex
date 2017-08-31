defmodule Dispatcher.Server do
  @moduledoc false

  use GenServer

  @global_name Application.get_env(:dispatcher, :global_name)

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: {:global, @global_name})
  end

  def run(data) do
  end
end
