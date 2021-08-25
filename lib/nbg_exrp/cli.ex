defmodule NbgExrp.CLI do
  @nbg_resource "https://nbg.gov.ge/gw/api/ct/monetarypolicy/currencies/ka/json"

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse(argv, strict: [help: :boolean, currency: :string], aliases: [h: :help, c: :currency])
    |> parse_flag()
  end

  def parse_flag({ [ {flag, value} ], _, _}) do
    { flag, value }
  end

  def parse_flag({[], _, _}) do
    { :help, true }
  end

  def process({ :help, _ }) do
    IO.puts """
    Usage: nbg_exrp -c usd
    """

    System.halt(0)
  end

  def process({:currency, currency}) do
    fetch_currencies()
    |> filter_by(currency)
  end

  def fetch_currencies do
    case HTTPoison.get(@nbg_resource) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
	Jason.decode! body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
	IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
	IO.inspect reason

    end
  end

  def filter_by([currencies|_], currency) do
    Map.fetch(currencies, "currencies")
    |> elem(1)
    |> Enum.filter(fn rec -> rec["code"] == String.upcase(currency) end)
    |> format_output
  end

  def format_output([rec|_]) do
    IO.puts "1 GEL = #{rec["rate"]} #{rec["code"]} (#{rec["name"]})"
  end
end
