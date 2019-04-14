defmodule Eurovision2019.Editions.Edition do
  use Ecto.Schema
  import Ecto.Changeset

  schema "editions" do
    field :year, :string
    has_many :participants, Eurovision2019.Participant

    timestamps()
  end

  @doc false
  def changeset(edition, attrs) do
    edition
    |> cast(attrs, [:year])
    |> validate_required([:year])
    |> unique_constraint(:year)
  end
end
