defmodule Eurovision2019Web.UserController do
  use Eurovision2019Web, :controller

  alias Eurovision2019.Accounts
  alias Eurovision2019.Accounts.User

  plug :check_auth when action in [:show, :new, :create, :edit, :update, :delete, :close]
  # plug :check_admin when action in [:show, :new, :create, :edit, :update, :delete, :close]

  defp check_admin(conn, _args) do
    with {:ok, current_user} <- get_current_user(conn),
         true <- is_admin?(current_user) do
      conn
      |> assign(:current_user, current_user)
    else
      _ ->
        conn
        |> put_flash(:error, "You need to be admin to access that page.")
        |> redirect(to: Routes.user_path(conn, :index))
        |> halt()
    end
  end

  defp is_admin?(%{admin: admin}), do: admin

  defp get_current_user(conn) do
    if user_id = get_session(conn, :current_user_id) do
      {:ok, Accounts.get_user!(user_id)}
    else
      {:error, :not_logged}
    end
  end

  defp check_auth(conn, _args) do
    case get_current_user(conn) do
      {:ok, current_user} ->
        conn
        |> assign(:current_user, current_user)

      _ ->
        conn
        |> put_flash(:error, "You need to be signed in to access that page.")
        |> redirect(to: Routes.user_path(conn, :index))
        |> halt()
    end
  end


  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed up successfully.")
        |> redirect(to: Routes.participant_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
