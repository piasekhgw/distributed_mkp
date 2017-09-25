defmodule Problem.Worker do
  @moduledoc false

  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def handle_cast({:solve, problem, problem_position, group_worker_pid}, state) do
    solved_problem = Problem.solve!(problem, Application.get_env(:problem, :executable_timeout))
    GenServer.cast(group_worker_pid, {:problem_solved, solved_problem, problem_position})
    {:stop, :normal, state}
  end
end
