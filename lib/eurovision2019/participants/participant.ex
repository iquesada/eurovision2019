defmodule Eurovision2019.Participants.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :country, :string
    field :description, :string
    field :name, :string
    field :video, :string
    field :photo, :string

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:name, :country, :description, :video, :photo])
    |> validate_required([:name, :country])
  end
end
