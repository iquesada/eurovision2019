defmodule Eurovision2019.Votings do
  @moduledoc false

  alias __MODULE__.Voting

  alias Eurovision2019.{Repo, Votes}

  @votes [1, 2, 3, 4, 5, 6, 7, 8, 10, 12]

  def create(%{id: user_id} = user, %{id: edition_id} = edition) do
    case completed?(user, edition) do
      :ok ->
        %Voting{}
        |> Voting.changeset(%{user_id: user_id, edition_id: edition_id})
        |> Repo.insert()

      {:error, error} ->
        {:error, error}
    end
  end

  def completed?(user, edition) do
    votes = Votes.user_votes_in_edition(user, edition)

    with true <- length(@votes) == length(votes),
         [] <- @votes -- votes do
      :ok
    else
      _ -> {:error, :incomplete}
    end
  end

  def get_voting(user, edition) do
    Voting |> Repo.get_by(user_id: user.id, edition_id: edition.id)
  end
end
