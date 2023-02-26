defmodule Cryptoid.Request do
  @moduledoc "CoinMarketCap api request"

  @base_url 'https://pro-api.coinmarketcap.com'

  def get(path) do
    url = @base_url ++ path

    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} = request(url, headers())

    Jason.decode!(body)
  end

  defp headers do
    api_key =
      Application.fetch_env!(:cryptoid, :cmc_api_key)
      |> String.to_charlist()

    [
      {'accept', 'application/json'},
      {'X-CMC_PRO_API_KEY', api_key}
    ]
  end

  defp request(url, headers) do
    :httpc.request(:get, {url, headers}, [], [])
  end
end
