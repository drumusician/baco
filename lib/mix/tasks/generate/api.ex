defmodule Mix.Tasks.Generate.Api do
  @moduledoc """
  Generate boilerplate setup for an API endpoint
  """

  @shortdoc "Create a new API endpoint"

  use Mix.Task
  alias Mix.Shell.IO

  def run(_argv) do
    IO.info("Great! Let's create a new API endpoint.")
    api_module = IO.prompt("Please provide the module name to use for this new API:")
    answer = IO.yes?("You have entered #{api_module}. Is that correct?")
    base_url = IO.prompt("Please provide the base_url for the api endpoint: ")

    case answer do
      false ->
        IO.info("You have entered no!")
        exit(:normal)

      _ ->
        ""
    end

    filename =
      api_module
      |> String.trim()
      |> String.downcase()

    Mix.Generator.create_file(
      "lib/api/#{filename}.ex",
      """
      defmodule MixHelp.Api.#{String.trim(api_module)} do
        @moduledoc false
        use HTTPoison.Base

        def process_url(url) do
          "#{String.trim(base_url)}" <> url
        end

        def process_response_body(body) do
          body
          |> Poison.decode!()
        end

      end
      """
    )
  end
end
