defmodule Eurovision2019.Helpers.Auth do
  @moduledoc false

  alias Eurovision2019.{Accounts, Repo}

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: !!Repo.get(Accounts.User, user_id)
  end
end
