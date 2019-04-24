defmodule Eurovision2019.Results.Result do
  use Ecto.Schema
  import Ecto.Changeset

  schema "results" do
    field :points, :integer
    belongs_to :participant, Eurovision2019.Participants.Participant
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, [:points, :participant_id])
    |> validate_required([:points])
    |> assoc_constraint(:participant)
  end
end
