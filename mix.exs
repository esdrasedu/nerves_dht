defmodule NervesDht.Mixfile do
  use Mix.Project

  def project do
    [app: :nerves_dht,
     version: "0.1.0",
     description: description(),
     package: package(),
     compilers: [:elixir_make] ++ Mix.compilers,
     build_embedded: true,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:elixir_make, "~> 0.6"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    "Drive of DHT 11 and DHT 22 (temperature and humidity sensor)"
  end

  defp package() do
    [
      name: "nerves_dht",
      files: ["src/**/*.h", "src/**/*.c", "lib", "priv", "test", "config", "mix.exs", "README.md", "LICENSE", "Makefile"],
      maintainers: ["Esdras Eduardo"],
      licenses: ["GNU 3.0"],
      links: %{"GitHub" => "https://github.com/esdrasedu/nerves_dht"}
    ]
  end

end
