defmodule NebulexCluster.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :nebulex_cluster,
      version: @version,
      elixir: "~> 1.7",
      deps: deps(),

      # Docs
      name: "NebulexCluster",
      docs: docs(),

      # Testing
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        credo: :test,
        dialyzer: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Dialyzer
      dialyzer: dialyzer(),

      # Hex
      package: package(),
      description: "Nebulex Cluster Utilities"
    ]
  end

  defp deps do
    [
      {:nebulex, github: "cabol/nebulex", optional: true},

      # Test & Code Analysis
      {:excoveralls, "~> 0.13", only: :test},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test]},
      {:ex_check, "~> 0.12", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.10", only: [:dev, :test], runtime: false},

      # Docs
      {:ex_doc, "~> 0.23", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      name: :nebulex_cluster,
      maintainers: ["Carlos Bolanos"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/cabol/nebulex_cluster"}
    ]
  end

  defp docs do
    [
      main: "NebulexCluster",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/nebulex_cluster",
      source_url: "https://github.com/cabol/nebulex_cluster"
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:nebulex],
      plt_file: {:no_warn, "priv/plts/" <> plt_file_name()},
      flags: [
        :unmatched_returns,
        :error_handling,
        :race_conditions,
        :no_opaque,
        :unknown,
        :no_return
      ]
    ]
  end

  defp plt_file_name do
    "dialyzer-#{Mix.env()}-#{System.version()}-#{System.version()}.plt"
  end
end
