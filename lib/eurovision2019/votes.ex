defmodule Eurovision2019.Votes do
  @moduledoc false

  import Ecto.Query

  alias __MODULE__.Vote
  alias Eurovision2019.Repo

  def vote(%{id: user_id} = user, %{id: participant_id} = participant, points) do
    attrs = %{user_id: user_id, participant_id: participant_id, points: points}

    with :ok <- check_vote(attrs),
         {:ok, vote} <- add_vote(user, participant, points) do
      {:ok, vote}
    else
      {:duplicated, vote} ->
        Repo.delete(vote)

        {:ok, add_vote(user, participant, points)}

      other ->
        other
    end
  end

  def user_votes_in_edition(%{id: user_id}, edition) do
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

  defp add_vote(_user, _participant, "0"), do: {:ok, %{}}

  defp add_vote(%{id: user_id} = user, %{id: participant_id} = participant, points) do
    attrs = %{user_id: user_id, participant_id: participant_id, points: points}

    {:ok,
     %Vote{}
     |> Vote.changeset(attrs)
     |> Repo.insert()}
  end

  defp check_vote(%{user_id: user_id, participant_id: participant_id}) do
    Repo.get_by(Vote, user_id: user_id, participant_id: participant_id)
    |> case do
      nil -> :ok
      vote -> {:duplicated, vote}
    end
  end

  defp valid_vote(0), do: {:error, :zero}
  defp valid_vote(_), do: {:ok, :valid}
end
