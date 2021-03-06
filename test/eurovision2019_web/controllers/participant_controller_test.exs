defmodule Eurovision2019Web.ParticipantControllerTest do
  use Eurovision2019Web.ConnCase

  alias Eurovision2019.{Accounts, Editions}

  setup %{conn: conn} do
    {:ok, user} = %{username: "test", encrypted_password: "123456"} |> Accounts.create_user()
    conn_with_user = conn |> Plug.Test.init_test_session(current_user_id: user.id)
    {:ok, conn: conn_with_user}
  end

  alias Eurovision2019.Participants

  @create_attrs %{country: "some country", description: "some description", name: "some name"}
  @update_attrs %{
    country: "some updated country",
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{country: nil, description: nil, name: nil}

  def fixture(:participant) do
    {:ok, edition} = %{year: "1990"} |> Editions.create_edition()
    new_attrs = @create_attrs |> Map.put(:edition_id, edition.id)

    {:ok, participant} = Participants.create_participant(new_attrs)
    participant
  end

  describe "index" do
    test "lists all participants", %{conn: conn} do
      conn = get(conn, Routes.participant_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Participants"
    end
  end

  describe "new participant" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.participant_path(conn, :new))
      assert html_response(conn, 200) =~ "New Participant"
    end
  end

  describe "create participant" do
    test "redirects to show when data is valid", %{conn: conn} do
      {:ok, edition} = %{year: "1990"} |> Editions.create_edition()
      new_attrs = @create_attrs |> Map.put(:edition_id, edition.id)

      conn = post(conn, Routes.participant_path(conn, :create), participant: new_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.participant_path(conn, :show, id)

      conn = get(conn, Routes.participant_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Participant"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.participant_path(conn, :create), participant: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Participant"
    end
  end

  describe "edit participant" do
    setup [:create_participant]

    test "renders form for editing chosen participant", %{conn: conn, participant: participant} do
      conn = get(conn, Routes.participant_path(conn, :edit, participant))
      assert html_response(conn, 200) =~ "Edit Participant"
    end
  end

  describe "update participant" do
    setup [:create_participant]

    test "redirects when data is valid", %{conn: conn, participant: participant} do
      conn =
        put(conn, Routes.participant_path(conn, :update, participant), participant: @update_attrs)

      assert redirected_to(conn) == Routes.participant_path(conn, :show, participant)

      conn = get(conn, Routes.participant_path(conn, :show, participant))
      assert html_response(conn, 200) =~ "some updated country"
    end

    test "renders errors when data is invalid", %{conn: conn, participant: participant} do
      conn =
        put(conn, Routes.participant_path(conn, :update, participant), participant: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Participant"
    end
  end

  describe "delete participant" do
    setup [:create_participant]

    test "deletes chosen participant", %{conn: conn, participant: participant} do
      conn = delete(conn, Routes.participant_path(conn, :delete, participant))
      assert redirected_to(conn) == Routes.participant_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.participant_path(conn, :show, participant))
      end
    end
  end

  defp create_participant(_) do
    participant = fixture(:participant)
    {:ok, participant: participant}
  end
end
