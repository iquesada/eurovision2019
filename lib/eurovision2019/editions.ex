defmodule Eurovision2019.Editions do
  @moduledoc """
  The Editions context.
  """

  import Ecto.Query, warn: false

  alias Eurovision2019.{
    Accounts.User,
    Participants.Participant,
    Repo,
    Results.Result,
    Votes.Vote,
    Votings.Voting
  }

  alias Eurovision2019.Editions.Edition

  @doc """
  Returns the list of editions.

  ## Examples

      iex> list_editions()
      [%Edition{}, ...]

  """
  def list_editions do
    Repo.all(Edition)
  end

  @doc """
  Gets a single edition.

  Raises `Ecto.NoResultsError` if the Edition does not exist.

  ## Examples

      iex> get_edition!(123)
      %Edition{}

      iex> get_edition!(456)
      ** (Ecto.NoResultsError)

  """
  def get_edition!(id), do: Repo.get!(Edition, id)

  @doc """
  Creates a edition.

  ## Examples

      iex> create_edition(%{field: value})
      {:ok, %Edition{}}

      iex> create_edition(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_edition(attrs \\ %{}) do
    %Edition{}
    |> Edition.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a edition.

  ## Examples

      iex> update_edition(edition, %{field: new_value})
      {:ok, %Edition{}}

      iex> update_edition(edition, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_edition(%Edition{} = edition, attrs) do
    edition
    |> Edition.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Edition.

  ## Examples

      iex> delete_edition(edition)
      {:ok, %Edition{}}

      iex> delete_edition(edition)
      {:error, %Ecto.Changeset{}}

  """
  def delete_edition(%Edition{} = edition) do
    Repo.delete(edition)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking edition changes.

  ## Examples

      iex> change_edition(edition)
      %Ecto.Changeset{source: %Edition{}}

  """
  def change_edition(%Edition{} = edition) do
    Edition.changeset(edition, %{})
  end

  def close_edition(%Edition{} = edition) do
    Ecto.assoc(edition, :participants)
    |> Repo.all()
    |> Enum.map(&create_result/1)

    edition
    |> Edition.changeset(%{closed: true})
    |> Repo.update()
  end

  defp create_result(%Participant{id: participant_id}) do
    points =
      from(vote in Vote,
        where: vote.participant_id == ^participant_id,
        join: user in User,
        where: vote.user_id == user.id,
        join: voting in Voting,
        where: voting.user_id == user.id
      )
      |> Repo.all()
      |> Enum.reduce(0, fn vote, acc -> vote.points + acc end)

    %Result{}
    |> Result.changeset(%{points: points, participant_id: participant_id})
    |> Repo.insert()
  end

  def fetch_edition_for_voting(id, user_id) do
    edition = get_edition!(id)

    participants =
      Ecto.assoc(edition, :participants)
      |> order_by(asc: :country)
      |> Repo.all()

    participant_ids = Enum.map(participants, & &1.id)

    raw_votes =
      from(vote in Vote,
        where: vote.participant_id in ^participant_ids and vote.user_id == ^user_id
      )
      |> Repo.all()

    votes =
      Enum.reduce(raw_votes, [], fn vote, acc -> [{vote.participant_id, vote.points} | acc] end)

    %{edition: edition, participants: participants, votes: votes}
  end
end
