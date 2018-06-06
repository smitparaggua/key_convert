defmodule KeyConvert.MixProject do
  use Mix.Project

  @github_url "https://github.com/smitparaggua/key_convert"

  def project do
    [
      app: :key_convert,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      name: "KeyConvert",
      source_url: @github_url,
      homepage_url: @github_url,
      docs: [extras: ["README.md"], main: "readme"],
      package: package(),
      description: "Convenience functions for converting Map keys",

      # Coveralls
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:excoveralls, "~> 0.8", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["John Smith Paraggua"],
      licenses: ["MIT"],
      links: %{"GitHub" => @github_url}
    ]
  end

  defp preferred_cli_env do
    [
      "coveralls": :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test
    ]
  end
end
