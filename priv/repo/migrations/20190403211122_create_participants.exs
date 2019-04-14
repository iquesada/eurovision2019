defmodule Eurovision2019.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add :name, :string
      add :country, :string
      add :description, :text

      timestamps()
    end
  end
end
