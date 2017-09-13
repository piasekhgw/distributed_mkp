use Mix.Config

config :dispatcher,
  name: {:global, :dispatcher},
  call_timeout: "DISPATCHER_CALL_TIMEOUT" |> System.get_env() |> String.to_integer(),
  dividers: %{
    initial: "DISPATCHER_INITIAL_DIVIDER" |> System.get_env() |> String.to_integer(),
    timeout: "DISPATCHER_TIMEOUT_DIVIDER" |> System.get_env() |> String.to_integer()
  }
