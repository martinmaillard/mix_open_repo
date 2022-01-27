defmodule Mix.Tasks.Hex.OpenRepo do
  use Mix.Task

  require Logger

  @shortdoc "Open Github repo for specified hex package"

  @impl Mix.Task
  def run(args) do
    open_repo(args, [])
  end

  defp open_repo(_args = [], _opts) do
    Mix.raise("You must specify the name of a package")
  end

  defp open_repo([package_name], opts) do
    open_repo(package_name, opts)
  end

  defp open_repo(package_name, opts) do
    case get_repo_url(package_name, opts) do
      nil ->
        Logger.error("Repo URL not found")
        exit({:shutdown, 1})

      url ->
        browser_open(url)
    end
  end

  defp get_repo_url(package_name, _opts) do
    case Hex.API.Package.get(nil, package_name) do
      {:ok, {code, body, _}} when code in 200..299 ->
        extract_repo_url(body)

      {:ok, {404, _, _}} ->
        Logger.error("No package with name #{package_name}")
        exit({:shutdown, 1})

      other ->
        Logger.error("Failed to retrieve package information")
        Logger.error(other)
        exit({:shutdown, 1})
    end
  end

  defp extract_repo_url(%{"meta" => %{"links" => links}}) do
    links
    |> Map.to_list()
    |> Enum.find_value(fn {key, value} ->
      if String.downcase(key) == "github" do
        value
      else
        nil
      end
    end)
  end

  defp extract_repo_url(_), do: nil

  defp browser_open(path) do
    path
    |> open_cmd()
    |> system_cmd()
  end

  defp open_cmd(path) do
    case :os.type() do
      {:win32, _} -> {"cmd", ["/c", "start", path]}
      {:unix, :darwin} -> {"open", [path]}
      {:unix, _} -> {"xdg-open", [path]}
    end
  end

  if Mix.env() == :test do
    defp system_cmd({cmd, args}) do
      send(self(), {:hex_system_cmd, cmd, args})
    end
  else
    defp system_cmd({cmd, args}) do
      System.cmd(cmd, args)
    end
  end
end
