defmodule NervesDht.Mixfile do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [app: :nerves_dht,
     version: "0.1.0",
     elixir: "~> 1.4",
     compilers: compilers(@target),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def compilers("host"),
    do: Mix.compilers

  def compilers(_target),
    do: [:elixir_make] ++ Mix.compilers

  defp deps do
    [{:elixir_make, "~> 0.4", runtime: false}]
  end
end
