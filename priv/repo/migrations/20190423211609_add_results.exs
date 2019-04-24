defmodule Eurovision2019.Repo.Migrations.AddResults do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :participant_id, references(:participants)
      add :points, :integer
    end
  end
end
