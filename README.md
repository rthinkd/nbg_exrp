# NbgExrp

## Descripion
```elixir
	-h, --help
	  Desc: Show help message
	  Usage: nbg_exrp -h, nbg_exrp --help
	-r, --rate
	  Desc: Show current rate for USD
	  Usage: nbg_exrp -r usd, nbg_exrp --rate usd

	--all
	  Desc: Shoo all currencies rates
	  Usage: nbg_exp --all

	-c, --convert
	 Desc: Convert amount in currenty to GEL
	 Usage: nbg_exrp -c 10 usd, nbg_exrp --conver 10 usd
```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `nbg_exrp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
	{:nbg_exrp, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/nbg_exrp](https://hexdocs.pm/nbg_exrp).
