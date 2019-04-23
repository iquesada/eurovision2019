defmodule Eurovision2019.Repo.Migrations.AddVoting do
  use Ecto.Migration

  def change do
    create table(:votings) do
      add :user_id, references(:users)
      add :edition_id, references(:editions)

      timestamps()
    end
  end
end
