defmodule NbgExrp.MixProject do
  use Mix.Project

  def project do
    [
      app: :nbg_exrp,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript_config()
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
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8"},
      {:decimal, "~> 2.0"},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end

  defp escript_config do
    [
      main_module: NbgExrp.CLI
    ]
  end
end
