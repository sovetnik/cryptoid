defmodule CryptoidWeb.RateLive.Index do
  use CryptoidWeb, :live_view

  alias Cryptoid.Storage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:currencies, Storage.currencies())}
  end

  @impl true
  def handle_event(
        "change",
        %{"rate" => %{"currency" => currency}},
        socket
      ) do
    {:noreply,
     socket
     |> push_redirect(to: Routes.rate_show_path(socket, :show, currency))}
  end
end
