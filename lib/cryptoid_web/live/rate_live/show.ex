defmodule CryptoidWeb.RateLive.Show do
  use CryptoidWeb, :live_view

  alias Cryptoid.Storage
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(Cryptoid.PubSub, "rates")

    {:ok, socket}
  end

  @impl true
  def handle_info(:rates_updated, socket) do
    {:noreply,
     socket
     |> assign(:currencies, currency_list())
     |> assign(:rate, Storage.rate(socket.assigns.selected_currency))}
  end

  @impl true
  def handle_params(%{"currency" => currency}, _, socket) do
    {:noreply,
     socket
     |> assign(:selected_currency, currency)
     |> assign(:currencies, currency_list())
     |> assign(:rate, Storage.rate(currency))}
  end

  @impl true
  def handle_event(
        "change",
        %{"rate" => %{"currency" => currency}},
        socket
      ) do
    {:noreply,
     socket
     |> push_patch(to: Routes.rate_show_path(socket, :show, currency))}
  end

  def currency_list do
    Storage.currencies() |> Enum.map(&{&1, &1})
  end
end
