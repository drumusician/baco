defmodule Mix.Tasks.Escript.New do
  @moduledoc """
  Create a new Mix project that is setup to create an escript
  """
  use Mix.Task
  alias Mix.Shell.IO

  @shortdoc "Create a new escript enabled mix project"

  def run([]) do
    IO.info("Let's create a new escript.")
    app_name = IO.prompt("Please give your project a name (this is used for mix new):")

    run([app_name])
  end

  def run(argv) do
    IO.info("Let's create a new escript.")
    app_name = appname(argv)
    module_name = modulename(argv)

    create_escript_project(app_name, module_name)
    IO.info("Escript successfully created!")
  end

  defp appname(argv) do
    argv
    |> List.first()
    |> String.trim()
  end

  defp modulename(argv) do
    argv
    |> List.first()
    |> String.split("_")
    |> Enum.map(&String.capitalize(&1))
    |> Enum.join()
  end

  defp create_escript_project(app_name, module_name) do
    System.cmd("mix", ["new", app_name])
    File.cd(app_name)
    create_main_module(app_name, module_name)
    overwrite_mix_exs(app_name, module_name)
  end

  defp create_main_module(app_name, module_name) do
    Mix.Generator.create_file(
      "lib/#{app_name}/cli.ex",
      """
      defmodule #{module_name}.CLI do
        @moduledoc false

        def main(_argv) do
          IO.puts "This is your new escript!"
        end

      end
      """
    )
  end

  defp overwrite_mix_exs(app_name, module_name) do
    Mix.Generator.create_file(
      "mix.exs",
      """
      defmodule #{module_name}.MixProject do
        use Mix.Project

        def project do
          [
            app: :#{app_name},
            version: "0.1.0",
            elixir: "~> 1.7",
            start_permanent: Mix.env() == :prod,
            deps: deps(),
            escript: [main_module: #{module_name}.CLI]
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
            # {:dep_from_hexpm, "~> 0.3.0"},
            # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
          ]
        end

      end
      """,
      [force: true]
    )
  end
end
