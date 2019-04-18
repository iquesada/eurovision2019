defmodule Eurovision2019.Votes do
  @moduledoc false

  alias __MODULE__.Vote
  alias Eurovision2019.Repo

  def vote(%{id: user_id}, %{id: participant_id}, points) do
    attrs = %{user_id: user_id, participant_id: participant_id, points: points}
    vote = %Vote{} |> Vote.changeset(attrs)

    with :ok <- check_vote(attrs),
         {:ok, vote} <- Repo.insert(vote) do
      {:ok, vote}
    else
      :duplicated -> {:error, :duplicated}
      other -> other
    end
  end

  defp check_vote(%{user_id: user_id, participant_id: participant_id, points: points}) do
    Repo.get_by(Vote, user_id: user_id, participant_id: participant_id, points: points)
    |> case do
      nil -> :ok
      _ -> :duplicated
    end
  end
end
