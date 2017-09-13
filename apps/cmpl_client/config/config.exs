use Mix.Config

config :cmpl_client,
  server_count: ("CMPL_CLIENT_COUNT") |> System.get_env() |> String.to_integer()
