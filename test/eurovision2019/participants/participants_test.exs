defmodule Eurovision2019.ParticipantsTest do
  use Eurovision2019.DataCase

  alias Eurovision2019.{Editions, Participants}

  describe "participants" do
    alias Eurovision2019.Participants.Participant

    @valid_attrs %{country: "some country", description: "some description", name: "some name"}
    @update_attrs %{
      country: "some updated country",
      description: "some updated description",
      name: "some updated name"
    }
    @invalid_attrs %{country: nil, description: nil, name: nil}

    def participant_fixture(attrs \\ %{}) do
      {:ok, edition} = %{year: "1990"} |> Editions.create_edition()
      new_attrs = @valid_attrs |> Map.put(:edition_id, edition.id)

      {:ok, participant} =
        attrs
        |> Enum.into(new_attrs)
        |> Participants.create_participant()

      participant
    end

    test "list_participants/0 returns all participants" do
      participant = participant_fixture(@valid_attrs)
      assert Participants.list_participants() == [participant]
    end

    test "get_participant!/1 returns the participant with given id" do
      participant = participant_fixture()
      assert Participants.get_participant!(participant.id) == participant
    end

    test "create_participant/1 with valid data creates a participant" do
      {:ok, edition} = %{year: "1991"} |> Editions.create_edition()
      attrs = @valid_attrs |> Map.put(:edition_id, edition.id)
      assert {:ok, %Participant{} = participant} = Participants.create_participant(attrs)
      assert participant.country == "some country"
      assert participant.description == "some description"
      assert participant.name == "some name"
    end

    test "create_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Participants.create_participant(@invalid_attrs)
    end

    test "update_participant/2 with valid data updates the participant" do
      participant = participant_fixture()

      assert {:ok, %Participant{} = participant} =
               Participants.update_participant(participant, @update_attrs)

      assert participant.country == "some updated country"
      assert participant.description == "some updated description"
      assert participant.name == "some updated name"
    end

    test "update_participant/2 with invalid data returns error changeset" do
      participant = participant_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Participants.update_participant(participant, @invalid_attrs)

      assert participant == Participants.get_participant!(participant.id)
    end

    test "delete_participant/1 deletes the participant" do
      participant = participant_fixture()
      assert {:ok, %Participant{}} = Participants.delete_participant(participant)
      assert_raise Ecto.NoResultsError, fn -> Participants.get_participant!(participant.id) end
    end

    test "change_participant/1 returns a participant changeset" do
      participant = participant_fixture()
      assert %Ecto.Changeset{} = Participants.change_participant(participant)
    end
  end
end
