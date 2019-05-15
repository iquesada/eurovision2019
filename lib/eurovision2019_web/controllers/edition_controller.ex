defmodule Eurovision2019Web.EditionController do
  use Eurovision2019Web, :controller
  alias Phoenix.LiveView

  require Logger

  alias Eurovision2019.Accounts
  alias Eurovision2019.Editions
  alias Eurovision2019.Editions.Edition
  alias Eurovision2019.Repo
  alias Eurovision2019.Results

  plug :check_auth when action in [:vote]
  plug :check_admin when action in [:new, :create, :edit, :update, :delete, :close]

  defp check_admin(conn, _args) do
    with {:ok, current_user} <- get_current_user(conn),
         true <- is_admin?(current_user) do
      conn
      |> assign(:current_user, current_user)
    else
      _ ->
        conn
        |> put_flash(:error, "You need to be admin to access that page.")
        |> redirect(to: Routes.edition_path(conn, :index))
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
        |> redirect(to: Routes.session_path(conn, :new))
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
        |> redirect(to: Routes.edition_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def vote(%{assigns: %{current_user: current_user}} = conn, _params) do
    case Editions.open_edition() do
      {:ok, %{id: edition_id}} ->
        session_data =
          Editions.fetch_edition_for_voting(edition_id, current_user.id)
          |> Map.put(:current_user, current_user)

        LiveView.Controller.live_render(conn, Eurovision2019Web.EditionVoteView,
          session: session_data
        )

      {:error, :not_found} ->
        conn
        |> put_flash(:info, "There are no edition active.")
        |> redirect(to: Routes.edition_path(conn, :index))
    end
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
        |> redirect(to: Routes.edition_path(conn, :index))

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

  def close(conn, %{"id" => id}) do
    Editions.get_edition!(id)
    |> Editions.close_edition()

    conn
    |> put_flash(:info, "Edition closed successfully.")
    |> redirect(to: Routes.edition_path(conn, :index))
  end

  def results(conn, _params) do
    case Editions.closed_edition() do
      {:ok, edition} ->
        render(conn, "results.html", results: Results.get_results(edition), edition: edition)

      _ ->
        render(conn, "no_results.html")
    end
  end
end
