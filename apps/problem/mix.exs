defmodule Problem.Mixfile do
  use Mix.Project

  def project do
    [
      app: :problem,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Problem.Application, []}
    ]
  end

  defp deps do
    [
      {:sweet_xml, "~> 0.6.5"},
      {:temp, "~> 0.4.3"}
    ]
  end
end
