defmodule Eurovision2019Web.PageController do
  use Eurovision2019Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
