defmodule NbgExrp.CLI do

  alias NbgExrp.CurrencyParser

  @default_currency "GEL"

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse(argv,
      strict: [help: :boolean, rate: :string, convert: :string],
      aliases: [h: :help, r: :rate, c: :convert])
    |> parse_flag()
  end

  def parse_flag({ [ {flag, value} ], other, _}) do
    { flag, value, other }
  end

  def parse_flag({[], _, _}) do
    { :help, true, true }
  end

  def process({ :help, _, _}) do
    IO.puts """
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
    """

    System.halt(0)
  end

  def process({:rate, currency, _}) do
    rec = currency |> CurrencyParser.parse

    IO.puts "1 #{@default_currency} = #{rec["rate"]} #{rec["code"]} (#{rec["name"]})"
  end

  def process({:convert, amount, [currency|_]}) do
    total = currency |> CurrencyParser.parse_and_calculate(amount)

    IO.puts "#{amount} #{currency} = #{total} #{@default_currency}"
  end
end
