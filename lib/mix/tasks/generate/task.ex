defmodule Mix.Tasks.Generate.Task do
  @moduledoc """
  Generate boilerplate for a new mix task
  """

  @shortdoc "Create a new mix task"

  use Mix.Task
  alias Mix.Shell.IO

  def run(_argv) do
    IO.info("Let's create a new mix task!")
    taskname = IO.prompt("What should we call this new task?")
    description = IO.prompt("PLease describe what your task does.")

    modulename =
      taskname
      |> String.trim()
      |> String.capitalize()

    Mix.Generator.create_file(
      "lib/mix/tasks/#{String.trim(taskname)}.ex",
      """
      defmodule Mix.Tasks.#{modulename} do
        @moduledoc \"""
        #{description}
        \"""

        use Mix.Task
        alias Mix.Shell.IO

        def run(_argv) do
          IO.info "Nothing implemented yet...\n Add your implementation in lib/mix/tasks/#{
        taskname
      }.ex"
        end
      end
      """
    )

    IO.info(
      "Task: #{taskname} created.\n Add your implementation in lib/mix/tasks/#{taskname}.ex"
    )
  end
end
