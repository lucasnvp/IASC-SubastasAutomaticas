defmodule SubastasApp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :subastas_app,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SubastasApp.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.10"},
      {:phoenix_pubsub, "~> 2.1"},
      {:gettext, "~> 0.19"},
      {:cowboy, "~> 2.9"},
      {:jason, "~> 1.0"},
      {:plug, "~> 1.13"},
      {:plug_cowboy, "~> 2.5"},
      {:memento, "~> 0.3"},
      {:libcluster, "~> 3.0"},
      {:poison, "~> 5.0"},
      {:httpoison, "~> 1.8"},
    ]
  end
end
