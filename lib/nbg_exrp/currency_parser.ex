defmodule NbgExrp.CurrencyParser do
  @nbg_resource "https://nbg.gov.ge/gw/api/ct/monetarypolicy/currencies/ka/json"

  def parse(currency) do
    fetch_currencies()
    |> filter_by(currency)
  end

  def parse_and_calculate(currency, amount) do
    currency |> parse |> calculate(amount)
  end

  def calculate(rec, amount) do
    Decimal.mult(Decimal.new(to_string(rec["rate"])), Decimal.new(amount))
  end

  def fetch_currencies do
    case HTTPoison.get(@nbg_resource) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
	Jason.decode! body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
	IO.puts "Not found :("
	System.halt(0)
      {:error, %HTTPoison.Error{reason: reason}} ->
	IO.inspect reason
	System.halt(0)
    end
  end

  def filter_by([currencies|_], currency) do
    Map.fetch(currencies, "currencies")
    |> elem(1)
    |> Enum.filter(fn rec -> rec["code"] == String.upcase(currency) end)
    |> first
  end

  def first([rec|_]) do
    rec
  end

  def first([]) do
    IO.puts "No info"
    System.halt(0)
  end

end
