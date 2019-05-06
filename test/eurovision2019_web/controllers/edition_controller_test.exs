defmodule Eurovision2019Web.EditionControllerTest do
  use Eurovision2019Web.ConnCase

  alias Eurovision2019.Accounts

  setup %{conn: conn} do
    {:ok, user} = %{username: "test", encrypted_password: "123456"} |> Accounts.create_user()
    conn_with_user = conn |> Plug.Test.init_test_session(current_user_id: user.id)
    {:ok, conn: conn_with_user}
  end

  alias Eurovision2019.Editions

  @create_attrs %{year: "some year"}
  @update_attrs %{year: "some updated year"}
  @invalid_attrs %{year: nil}

  def fixture(:edition) do
    {:ok, edition} = Editions.create_edition(@create_attrs)
    edition
  end

  describe "index" do
    test "lists all editions", %{conn: conn} do
      conn = get(conn, Routes.edition_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Editions"
    end
  end

  describe "new edition" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.edition_path(conn, :new))
      assert html_response(conn, 200) =~ "New Edition"
    end
  end

  describe "create edition" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.edition_path(conn, :create), edition: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.edition_path(conn, :show, id)

      conn = get(conn, Routes.edition_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Edition created"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.edition_path(conn, :create), edition: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Edition"
    end
  end

  describe "edit edition" do
    setup [:create_edition]

    test "renders form for editing chosen edition", %{conn: conn, edition: edition} do
      conn = get(conn, Routes.edition_path(conn, :edit, edition))
      assert html_response(conn, 200) =~ "Edit Edition"
    end
  end

  describe "update edition" do
    setup [:create_edition]

    test "redirects when data is valid", %{conn: conn, edition: edition} do
      conn = put(conn, Routes.edition_path(conn, :update, edition), edition: @update_attrs)
      assert redirected_to(conn) == Routes.edition_path(conn, :show, edition)

      conn = get(conn, Routes.edition_path(conn, :show, edition))
      assert html_response(conn, 200) =~ "some updated year"
    end

    test "renders errors when data is invalid", %{conn: conn, edition: edition} do
      conn = put(conn, Routes.edition_path(conn, :update, edition), edition: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Edition"
    end
  end

  describe "delete edition" do
    setup [:create_edition]

    test "deletes chosen edition", %{conn: conn, edition: edition} do
      conn = delete(conn, Routes.edition_path(conn, :delete, edition))
      assert redirected_to(conn) == Routes.edition_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.edition_path(conn, :show, edition))
      end
    end
  end

  defp create_edition(_) do
    edition = fixture(:edition)
    {:ok, edition: edition}
  end
end
