defmodule RinhaCompiler.MixProject do
  use Mix.Project

  def project do
    [
      app: :rinha_compiler_ex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  def releases do
    [
      rinha: [
        steps: [:assemble, &Bakeware.assemble/1]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RinhaCompiler.Main, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.29.1"},
      {:jason, "~> 1.4"},
      {:bakeware, "~> 0.2.4"}
    ]
  end
end
