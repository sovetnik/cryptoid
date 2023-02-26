defmodule CryptoidWeb.RateLive.FormComponent do
  use CryptoidWeb, :live_component

  alias Cryptoid.Storage

  @impl true
  def update(%{rate: rate} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event(
        "change",
        %{"rate" => %{"currency" => currency}},
        socket
      ) do
    IO.inspect(currency, label: :event_currency)

    {:noreply,
     socket
     |> assign(:page_title, "Currency rate")
     |> assign(:currencies, Storage.currencies())
     |> assign(:rate, Storage.rate(currency))}
  end

  def handle_event("save", %{"rate" => rate_params}, socket) do
    save_rate(socket, socket.assigns.action, rate_params)
  end

  defp save_rate(socket, :edit, rate_params) do
    # case Crypto.update_rate(socket.assigns.rate, rate_params) do
    #   {:ok, _rate} ->
    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "Rate updated successfully")
    #      |> push_redirect(to: socket.assigns.return_to)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, :changeset, changeset)}
    # end
    {:noreply, socket}
  end

  defp save_rate(socket, :new, rate_params) do
    # case Crypto.create_rate(rate_params) do
    #   {:ok, _rate} ->
    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "Rate created successfully")
    #      |> push_redirect(to: socket.assigns.return_to)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, changeset: changeset)}
    # end
    {:noreply, socket}
  end
end
