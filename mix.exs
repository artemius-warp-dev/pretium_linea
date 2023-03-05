defmodule PretiumLinea.MixProject do
  use Mix.Project

  def project do
    [
      app: :pretium_linea,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [
        plt_add_deps: :transitive,
        remove_defaults: [:unknown]
      ],
      docs: docs(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PretiumLinea.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.16"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:saxy, "~> 1.5"},
      {:open_api_spex, "~> 3.16"},
      {:ymlr, "~> 2.0"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:credo, "> 0.9.2", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:excoveralls, "~> 0.16", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end

  defp docs do
    [
      groups_for_modules: groups_for_modules()
    ]
  end

  defp groups_for_modules do
    [
      Core: [
        PretiumLinea,
        PretiumLinea.Process,
        PretiumLinea.Types
      ],
      AFKL: [
        PretiumLinea.AFKL,
        PretiumLinea.AFKL.Server,
        PretiumLinea.AFKL.Offer,
        PretiumLinea.AFKL.Handler
      ],
      BA: [
        PretiumLinea.BA,
        PretiumLinea.BA.Server,
        PretiumLinea.BA.Offer,
        PretiumLinea.BA.Handler
      ],
      API: [
        PretiumLineaWeb.OfferController,
        PretiumLineaWeb.OfferView,
        PretiumLineaWeb.ApiSpec
      ],
      Phoenix: [
        PretiumLineaWeb,
        PretiumLineaWeb.Endpoint,
        PretiumLineaWeb.ErrorHelpers,
        PretiumLineaWeb.Router,
        PretiumLineaWeb.Router.Helpers
      ],
      Schemas: [
        PretiumLineaWeb.Schema.Offers
      ]
    ]
  end
end
