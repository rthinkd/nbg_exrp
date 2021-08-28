defmodule NbgExrp.CLI do
  alias NbgExrp.CurrencyParser

  @default_currency "GEL"

  def main(argv) do
    argv
    |> fetch_and_process
    |> format_output
  end

  def fetch_and_process(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse(argv,
      strict: [help: :boolean, rate: :string, convert: :string, all: :boolean],
      aliases: [h: :help, r: :rate, c: :convert]
    )
    |> parse_flag()
  end

  def parse_flag({[{flag, value}], other, _}) do
    {flag, value, other}
  end

  def parse_flag({[], _, _}) do
    {:help, true, true}
  end

  def process({:help, _, _}) do
    IO.puts("""
    DESCRIPION

    -h, --help
      Desc: Show help message
      Usage: nbg_exrp -h, nbg_exrp --help
    -r, --rate
      Desc: Show current rate for USD
      Usage: nbg_exrp -r usd, nbg_exrp --rate usd

    -c, --convert
     Desc: Convert amount in currenty to GEL
     Usage: nbg_exrp -c 10 usd, nbg_exrp --conver 10 usd
    """)

    System.halt(0)
  end

  def process({:rate, currency, other}) do
    records = [currency | other] |> CurrencyParser.parse()

    {:rate, records}
  end

  def process({:all, _, _}) do
    records = CurrencyParser.parse([])

    {:rate_all, records}
  end

  def process({:convert, amount, currency}) do
    total = currency |> CurrencyParser.parse_and_calculate(amount)

    {:convert, [%{total: total, amount: amount, currency: currency}]}
  end

  def format_output({:rate, records}) do
    records
    |> Enum.each(fn rec ->
      IO.puts("1 #{@default_currency} = #{rec["rate"]} #{rec["code"]} (#{rec["name"]})")
    end)
  end

  def format_output({:convert, records}) do
    records
    |> Enum.each(fn rec ->
      IO.puts("#{rec[:amount]} #{rec[:currency]} = #{rec[:total]} #{@default_currency}")
    end)
  end

  def format_output({:rate_all, records}) do
    records
    |> Enum.each(fn rec ->
      IO.puts("1 #{@default_currency} = #{rec["rate"]} #{rec["code"]} (#{rec["name"]})")
    end)
  end
end
