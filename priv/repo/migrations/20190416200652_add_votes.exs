defmodule Eurovision2019.Repo.Migrations.AddVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :user_id, references(:users)
      add :participant_id, references(:participants)
      add :points, :integer
    end
  end
end
