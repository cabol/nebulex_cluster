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
      {:nebulex, github: "cabol/nebulex", branch: "master"},

      # Test
      {:excoveralls, "~> 0.6", only: :test},
      {:benchee, "~> 0.13", optional: true, only: :dev},
      {:benchee_html, "~> 0.5", optional: true, only: :dev},

      # Code Analysis
      {:dialyxir, "~> 0.5", optional: true, only: [:dev, :test], runtime: false},
      {:credo, "~> 0.10", optional: true, only: [:dev, :test]},

      # Docs
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:inch_ex, "~> 0.5", only: :docs}
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
      plt_add_apps: [:nebulex, :shards, :mix, :eex],
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
end
