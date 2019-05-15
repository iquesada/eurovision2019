defmodule Eurovision2019.VotingsTest do
  @moduledoc false

  use Eurovision2019.DataCase

  alias Eurovision2019.{
    Accounts,
    Editions,
    Participants,
    Votes,
    Votings,
    Votings.Voting
  }

  @votes [1, 2, 3, 4, 5, 6, 7, 8, 10, 12]
  @incomplete_votes [1, 3, 4, 6, 7, 8]

  describe "create/2" do
    test "on success" do
      {:ok, user} =
        %{username: "votes_test_1", encrypted_password: "123456"} |> Accounts.create_user()

      {:ok, edition} = %{year: "votes_test_year_1"} |> Editions.create_edition()

      participant_base = %{name: "votes_test_", country: "country", edition_id: edition.id}

      participants =
        Enum.map(@votes, fn x ->
          {Map.put(participant_base, :name, "voting_test_#{x}")
           |> Participants.create_participant(), x}
        end)

      Enum.map(participants, fn {{:ok, participant}, vote} ->
        Votes.vote(user, participant, vote)
      end)

      assert {:ok, %Voting{}} = Votings.create(user, edition)
    end

    test "on error voting not completed" do
      {:ok, user} =
        %{username: "votes_test_3", encrypted_password: "123456"} |> Accounts.create_user()

      {:ok, edition} = %{year: "votes_test_year_3"} |> Editions.create_edition()

      participant_base = %{name: "votes_test_", country: "country", edition_id: edition.id}

      participants =
        Enum.map(@incomplete_votes, fn x ->
          {Map.put(participant_base, :name, "voting_test_#{x}")
           |> Participants.create_participant(), x}
        end)

      Enum.map(participants, fn {{:ok, participant}, vote} ->
        Votes.vote(user, participant, vote)
      end)

      assert {:error, :incomplete} == Votings.create(user, edition)
    end

    test "on error user has voted" do
      {:ok, user} =
        %{username: "votes_test_4", encrypted_password: "123456"} |> Accounts.create_user()

      {:ok, edition} = %{year: "votes_test_year_4"} |> Editions.create_edition()

      participant_base = %{name: "votes_test_", country: "country", edition_id: edition.id}

      participants =
        Enum.map(@votes, fn x ->
          {Map.put(participant_base, :name, "voting_test_#{x}")
           |> Participants.create_participant(), x}
        end)

      Enum.map(participants, fn {{:ok, participant}, vote} ->
        Votes.vote(user, participant, vote)
      end)

      assert {:ok, %Voting{}} = Votings.create(user, edition)
      assert {:error, :duplicated} = Votings.create(user, edition)
    end
  end
end
