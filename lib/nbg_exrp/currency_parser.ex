defmodule NbgExrp.CurrencyParser do
  alias NbgExrp.FileStorage

  @nbg_resource "https://nbg.gov.ge/gw/api/ct/monetarypolicy/currencies/ka/json"

  def parse(currencies) do
    fetch_currencies()
    |> filter_by(currencies)
  end

  def parse_and_calculate(currency, amount) do
    currency |> parse |> calculate(amount)
  end

  def calculate([rec | _], amount) do
    Decimal.mult(Decimal.new(to_string(rec["rate"])), Decimal.new(amount))
  end

  def fetch_currencies do
    case FileStorage.read() do
      {:ok, file} ->
	Jason.decode!(file)

      {:error, _} ->
	case HTTPoison.get(@nbg_resource) do
	  {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
	    FileStorage.store(body)
	    Jason.decode!(body)

	  {:ok, %HTTPoison.Response{status_code: 404}} ->
	    IO.puts("Not found :(")
	    System.halt(0)

	  {:error, %HTTPoison.Error{reason: reason}} ->
	    IO.inspect(reason)
	    System.halt(0)
	end
    end
  end

  def filter_by([crecords | _], currencies) do
    normalized_currencies = Enum.map(currencies, &String.upcase/1)

    Map.fetch(crecords, "currencies")
    |> elem(1)
    |> Enum.filter(fn rec -> is_member?(normalized_currencies, rec["code"]) end)
    |> validate
  end

  def is_member?([head | tail], code) do
    Enum.member?([head | tail], code)
  end

  def is_member?([], _) do
    true
  end

  def validate([a | b]) do
    [a | b]
  end

  def validate([]) do
    IO.puts("No info")
    System.halt(0)
  end
end
