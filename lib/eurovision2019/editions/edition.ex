defmodule Eurovision2019.Editions.Edition do
  use Ecto.Schema
  import Ecto.Changeset

  schema "editions" do
    field :year, :string
    field :open, :boolean, default: false
    field :closed, :boolean, default: false
    has_many :participants, Eurovision2019.Participants.Participant, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(edition, attrs) do
    edition
    |> cast(attrs, [:year, :closed, :open])
    |> validate_required([:year])
    |> unique_constraint(:year)
  end
end
