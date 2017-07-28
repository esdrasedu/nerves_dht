defmodule NervesDht.Mixfile do
  use Mix.Project

  def project do
    [app: :nerves_dht,
     version: "0.1.0",
     elixir: "~> 1.5",
     compilers: [:elixir_make] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:elixir_make, "~> 0.4", runtime: false}]
  end
end
