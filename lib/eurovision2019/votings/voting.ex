defmodule Eurovision2019.Votings.Voting do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "votings" do
    belongs_to :edition, Eurovision2019.Editions.Edition
    belongs_to :user, Eurovision2019.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(voting, attrs) do
    voting
    |> cast(attrs, [:edition_id, :user_id])
    |> assoc_constraint(:edition)
    |> assoc_constraint(:user)
  end
end
