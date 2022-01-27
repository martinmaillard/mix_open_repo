defmodule MixOpenRepo.MixProject do
  use Mix.Project

  @version "0.1.0"
  @repo_url "https://github.com/martinmaillard/mix_open_repo"

  def project do
    [
      app: :mix_open_repo,
      version: @version,
      elixir: "~> 1.8",
      description:
        "Provides a `mix hex.open_repo` task to open the Github repository of a Hex package",
      source_url: @repo_url,
      homepage_url: @repo_url,
      start_permanent: false,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [
      mod: {MixOpenRepo, []},
      extra_applications: [:logger, :hex]
    ]
  end

  defp deps do
    [
      {:hex_core, "~> 0.0"}
    ]
  end

  defp package do
    %{
      name: "mix hex.open_repo",
      maintainers: ["Martin Maillard"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @repo_url
      },
      files: ~w(LICENSE README.md CHANGELOG.md lib mix.exs)
    }
  end

  defp docs do
    [
      extras: ["README.md", "CHANGELOG.md"],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @repo_url
    ]
  end
end
