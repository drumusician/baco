defmodule Baco.MixProject do
  use Mix.Project

  def project do
    [
      app: :baco,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      source_url: "https://github.com/drumusician/baco",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19.1"}
    ]
  end

  defp package do
    [
      maintainers: ["Tjaco Oostdijk"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/drumusician/baco"
      }
    ]
  end

  defp description do
    """
    A Useful tool to use inside your Mix projects
    """
  end
end
