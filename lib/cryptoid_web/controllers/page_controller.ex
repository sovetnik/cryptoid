defmodule CryptoidWeb.PageController do
  use CryptoidWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
