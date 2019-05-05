defmodule Eurovision2019.Votes do
  @moduledoc false

  import Ecto.Query

  alias __MODULE__.Vote
  alias Eurovision2019.Repo

  def vote(%{id: user_id}, %{id: participant_id}, points) do
    attrs = %{user_id: user_id, participant_id: participant_id, points: points}
    vote = %Vote{} |> Vote.changeset(attrs)

    with :ok <- check_vote(attrs),
         {:ok, vote} <- Repo.insert(vote) do
      {:ok, vote}
    else
      {:duplicated, vote} ->
        {:ok,
         vote
         |> Vote.changeset(%{points: points})
         |> Repo.update()}

      other ->
        other
    end
  end

  def user_votes_in_edition(%{id: user_id}, %{id: edition_id} = edition) do
    participants =
      Ecto.assoc(edition, :participants)
      |> Repo.all()
      |> Enum.map(& &1.id)

    from(vote in Vote,
      where:
        vote.user_id == ^user_id and vote.participant_id in ^participants and vote.points > 0,
      select: vote.points
    )
    |> Repo.all()
  end

  defp check_vote(%{user_id: user_id, participant_id: participant_id}) do
    Repo.get_by(Vote, user_id: user_id, participant_id: participant_id)
    |> case do
      nil -> :ok
      vote -> {:duplicated, vote}
    end
  end
end
