defmodule CLITest do
  use ExUnit.Case, async: false

  alias NbgExrp.CLI

  doctest CLI

  import Mock

  describe "with passed flag" do
    test "--rate usd returns currency" do
      with_mock HTTPoison, get: fn _url -> response() end do
        {:rate, [rec | _]} = CLI.fetch_and_process(["--rate", "usd"])

        assert rec["code"] == "USD"
      end
    end

    test "-r usd returns currency" do
      with_mock HTTPoison, get: fn _url -> response() end do
        {:rate, [rec | _]} = CLI.fetch_and_process(["-r", "usd"])

        assert rec["code"] == "USD"
      end
    end

    test "-r usd eur returns currencies" do
      with_mock HTTPoison, get: fn _url -> response() end do
        {:rate, crecords} = CLI.fetch_and_process(["-r", "usd", "eur"])

        assert length(crecords) == 2
      end
    end

    test "--convert 10 usd returnes converted currency" do
      with_mock HTTPoison, get: fn _url -> response() end do
        {:convert, [rec | _]} = CLI.fetch_and_process(["--convert", 10, "usd"])

        assert Map.has_key?(rec, :total) == true
        assert rec[:amount] == 10
      end
    end

    test "-c 10 usd returnes converted currency" do
      with_mock HTTPoison, get: fn _url -> response() end do
        {:convert, [rec | _]} = CLI.fetch_and_process(["-c", 10, "usd"])

        assert Map.has_key?(rec, :total) == true
        assert rec[:amount] == 10
      end
    end

    test "--all returns all currencies" do
      with_mock HTTPoison, get: fn _url -> response() end do
        {:rate_all, crecords} = CLI.fetch_and_process(["--all"])

        assert length(crecords) == 3
      end
    end
  end

  defp response do
    result = [
      %{
        "date" => "2021-08-26T00:00:00.000Z",
        "currencies" => [
          %{
            "code" => "EUR",
            "date" => "2021-08-26T17:45:03.649Z",
            "diff" => 0.0077,
            "diffFormated" => "0.0077",
            "name" => "ევრო",
            "quantity" => 1,
            "rate" => 3.6842,
            "rateFormated" => "3.6842",
            "validFromDate" => "2021-08-27T00:00:00.000Z"
          },
          %{
            "code" => "USD",
            "date" => "2021-08-26T17:45:03.649Z",
            "diff" => -0.0017,
            "diffFormated" => "0.0017",
            "name" => "აშშ დოლარი",
            "quantity" => 1,
            "rate" => 3.1288,
            "rateFormated" => "3.1288",
            "validFromDate" => "2021-08-27T00:00:00.000Z"
          },
          %{
            "code" => "RUB",
            "date" => "2021-08-26T17:45:03.649Z",
            "diff" => -0.0010,
            "diffFormated" => "0.0010",
            "name" => "რუსული რუბლი",
            "quantity" => 1,
            "rate" => 0.4531,
            "rateFormated" => "0.4531",
            "validFromDate" => "2021-08-27T00:00:00.000Z"
          }
        ]
      }
    ]

    {:ok, body} = Jason.encode(result)

    {:ok, %HTTPoison.Response{status_code: 200, body: body}}
  end
end
