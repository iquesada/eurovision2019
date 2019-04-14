defmodule Eurovision2019.Repo.Migrations.AddEditionToParticipant do
  use Ecto.Migration

  def change do
    alter table(:participants) do
      add :edition_id, references(:editions)
    end
  end
end
