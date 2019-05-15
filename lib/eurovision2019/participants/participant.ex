defmodule Eurovision2019.Participants.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :country, :string
    field :description, :string
    field :name, :string
    field :video, :string
    field :photo, :string
    belongs_to :edition, Eurovision2019.Editions.Edition
    has_many :votes, Eurovision2019.Votes.Vote, on_delete: :delete_all
    has_many :results, Eurovision2019.Results.Result, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:name, :country, :description, :video, :photo, :edition_id])
    |> validate_required([:name, :country, :edition_id])
    |> assoc_constraint(:edition)
  end
end
