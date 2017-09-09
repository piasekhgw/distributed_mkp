use Mix.Config

config :problem,
  cmpl_timeout: ("CMPL_TIMEOUT") |> System.get_env() |> String.to_integer(),
  template_path: "templates/mkp.eex"
