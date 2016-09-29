Code.require_file "../app_one/mixtools.exs"

defmodule MasterApp.Mixfile do
  use Mix.Project

  def project do
    [app: :master_app,
     version: AppOne.MixTools.get_version,
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :app_one, :app_two],
     mod: {MasterApp, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:app_one, in_umbrella: true},
     {:app_two, in_umbrella: true}, ]
  end
end
