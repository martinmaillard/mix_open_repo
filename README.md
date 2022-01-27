
# mix hex.open_repo

MixOpenRepo provides a `mix hex.open_repo` task to open the Github repository
of a hex package in the default browser.

## Installation

Add `mix_open_repo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mix_open_repo, "~> 0.1.0", only: :dev, runtime: false},
  ]
end
```

Then run `mix do deps.get, deps.compile`.

## Usage

`mix hex.open_repo <package>` e.g. `mix hex.open_repo ecto`


