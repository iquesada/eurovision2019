defmodule Eurovision2019Web.EditionController do
  use Eurovision2019Web, :controller

  alias Eurovision2019.Accounts
  alias Eurovision2019.Editions
  alias Eurovision2019.Editions.Edition

  plug :check_auth when action in [:new, :create, :edit, :update, :delete]

  defp check_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id)

      conn
      |> assign(:current_user, current_user)
    else
      conn
      |> put_flash(:error, "You need to be signed in to access that page.")
      |> redirect(to: Routes.edition_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    editions = Editions.list_editions()
    render(conn, "index.html", editions: editions)
  end

  def new(conn, _params) do
    changeset = Editions.change_edition(%Edition{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"edition" => edition_params}) do
    case Editions.create_edition(edition_params) do
      {:ok, edition} ->
        conn
        |> put_flash(:info, "Edition created successfully.")
        |> redirect(to: Routes.edition_path(conn, :show, edition))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    edition = Editions.get_edition!(id)
    render(conn, "show.html", edition: edition)
  end

  def edit(conn, %{"id" => id}) do
    edition = Editions.get_edition!(id)
    changeset = Editions.change_edition(edition)
    render(conn, "edit.html", edition: edition, changeset: changeset)
  end

  def update(conn, %{"id" => id, "edition" => edition_params}) do
    edition = Editions.get_edition!(id)

    case Editions.update_edition(edition, edition_params) do
      {:ok, edition} ->
        conn
        |> put_flash(:info, "Edition updated successfully.")
        |> redirect(to: Routes.edition_path(conn, :show, edition))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", edition: edition, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    edition = Editions.get_edition!(id)
    {:ok, _edition} = Editions.delete_edition(edition)

    conn
    |> put_flash(:info, "Edition deleted successfully.")
    |> redirect(to: Routes.edition_path(conn, :index))
  end
end
