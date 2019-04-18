defmodule Eurovision2019.VotesTest do
  @moduledoc false

  use Eurovision2019.DataCase

  alias Eurovision2019.{
    Accounts,
    Editions,
    Participants,
    Repo,
    Votes,
    Votes.Vote
  }

  describe "vote/3" do
    test "on sucess when data is correct" do
      {:ok, user} =
        %{username: "votes_test_1", encrypted_password: "123456"} |> Accounts.create_user()

      {:ok, edition} = %{year: "votes_test_year_1"} |> Editions.create_edition()

      {:ok, participant} =
        %{name: "votes_test_1", country: "country", edition_id: edition.id}
        |> Participants.create_participant()

      points = 5

      assert {:ok, _vote} = Votes.vote(user, participant, points)
      result = Repo.get_by(Vote, user_id: user.id, participant_id: participant.id)
      assert points == result.points
    end

    test "error repeated vote" do
      {:ok, user} =
        %{username: "votes_test_2", encrypted_password: "123456"} |> Accounts.create_user()

      {:ok, edition} = %{year: "votes_test_year_2"} |> Editions.create_edition()

      {:ok, participant} =
        %{name: "votes_test_2", country: "country", edition_id: edition.id}
        |> Participants.create_participant()

      points = 5

      assert {:ok, _vote} = Votes.vote(user, participant, points)
      assert {:error, :duplicated} = Votes.vote(user, participant, points)
    end
  end
end
