defmodule Eurovision2019.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :points, :integer
    belongs_to :participant, Eurovision2019.Participants.Participant
    belongs_to :user, Eurovision2019.Accounts.User
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:points, :participant_id, :user_id])
    |> validate_required([:points])
    |> assoc_constraint(:participant)
    |> assoc_constraint(:user)
  end
end
