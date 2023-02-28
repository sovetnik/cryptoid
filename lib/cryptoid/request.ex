defmodule Cryptoid.Request do
  @moduledoc "CoinMarketCap api request"

  @base_url 'https://pro-api.coinmarketcap.com'

  require Logger

  def get(path) do
    @base_url
    |> Kernel.++(path)
    |> request(headers())
    |> handle_response()
    |> Jason.decode!()
  end

  def handle_response({:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}}) do
    Logger.notice("Got rates: " <> inspect(NaiveDateTime.local_now()))
    body
  end

  def handle_response({:ok, {{'HTTP/1.1', 404, 'Not Found'}, _headers, body}}) do
    Logger.error(body)
    body
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
