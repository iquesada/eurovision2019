defmodule Eurovision2019Web.EditionVoteView do
  use Phoenix.LiveView
  require Logger

  alias Eurovision2019.{Editions, Votes, Votings}

  def render(assigns) do
    Eurovision2019Web.PageView.render("edition_vote.html", assigns)
  end

  def mount(session, socket) do
    {:ok,
     assign(socket,
       current_user: session.current_user,
       participants: session.participants,
       edition: session.edition,
       votes: session.votes
     )
     |> set_socket_data()}
  end

  def handle_event("vote", %{"id" => id, "points" => points}, %{assigns: assigns} = socket) do
    Votes.vote(assigns.current_user, %{id: String.to_integer(id)}, points)
    editions_data = Editions.fetch_edition_for_voting(assigns.edition.id, assigns.current_user.id)
    {:noreply, set_socket_data(socket) |> assign(:votes, editions_data.votes)}
  end

  def handle_event("send", _, %{assigns: assigns} = socket) do
    case Votings.create(assigns.current_user, assigns.edition) do
      {:ok, _} -> {:noreply, assign(socket, :completed, true)}
      _ -> {:noreply, set_socket_data(socket) |> assign(:send_error, true)}
    end
  end

  defp set_socket_data(socket) do
    socket
    |> set_completed()
    |> set_closed()
  end

  defp set_completed(%{assigns: %{current_user: current_user, edition: edition}} = socket) do
    case Votings.completed?(current_user, edition) do
      :ok ->
        assign(socket, :completed, true)

      _ ->
        assign(socket, :completed, false)
    end
  end

  defp set_completed(socket) do
    assign(socket, :completed, false)
  end

  defp set_closed(%{assigns: %{current_user: current_user, edition: edition}} = socket) do
    case Votings.get_voting(current_user, edition) do
      nil -> assign(socket, :closed, false)
      _ -> assign(socket, :closed, true)
    end
  end
end
