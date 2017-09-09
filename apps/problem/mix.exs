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

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:temp, "~> 0.4.3"},
      {:sweet_xml, "~> 0.6.5"},
      {:ex_doc, "~> 0.16.3"}
    ]
  end
end
