use Mix.Config

config :dispatcher,
  global_name: :dispatcher,
  worker_present: System.get_env("DISPATCHER_WORKER_PRESENT") === "true"
