defmodule Eurovision2019.EditionsTest do
  use Eurovision2019.DataCase

  alias Eurovision2019.Editions

  describe "editions" do
    alias Eurovision2019.Editions.Edition

    @valid_attrs %{year: "some year"}
    @update_attrs %{year: "some updated year"}
    @invalid_attrs %{year: nil}

    def edition_fixture(attrs \\ %{}) do
      {:ok, edition} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Editions.create_edition()

      edition
    end

    test "list_editions/0 returns all editions" do
      edition = edition_fixture()
      assert Editions.list_editions() == [edition]
    end

    test "get_edition!/1 returns the edition with given id" do
      edition = edition_fixture()
      assert Editions.get_edition!(edition.id) == edition
    end

    test "create_edition/1 with valid data creates a edition" do
      assert {:ok, %Edition{} = edition} = Editions.create_edition(@valid_attrs)
      assert edition.year == "some year"
    end

    test "create_edition/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Editions.create_edition(@invalid_attrs)
    end

    test "update_edition/2 with valid data updates the edition" do
      edition = edition_fixture()
      assert {:ok, %Edition{} = edition} = Editions.update_edition(edition, @update_attrs)
      assert edition.year == "some updated year"
    end

    test "update_edition/2 with invalid data returns error changeset" do
      edition = edition_fixture()
      assert {:error, %Ecto.Changeset{}} = Editions.update_edition(edition, @invalid_attrs)
      assert edition == Editions.get_edition!(edition.id)
    end

    test "delete_edition/1 deletes the edition" do
      edition = edition_fixture()
      assert {:ok, %Edition{}} = Editions.delete_edition(edition)
      assert_raise Ecto.NoResultsError, fn -> Editions.get_edition!(edition.id) end
    end

    test "change_edition/1 returns a edition changeset" do
      edition = edition_fixture()
      assert %Ecto.Changeset{} = Editions.change_edition(edition)
    end
  end
end
