use Mix.Config

config :cmpl_client,
  problem_template_path: "templates/mkp.eex",
  group_name: :cmpl_clients,
  worker_count: "CMPL_CLIENT_WORKER_COUNT" |> System.get_env() |> String.to_integer(),
  executable_timeout: "CMPL_EXECUTABLE_TIMEOUT" |> System.get_env() |> String.to_integer()
