defmodule Eurovision2019.Repo.Migrations.AddVideoToParticipants do
  use Ecto.Migration

  def change do
    alter table(:participants) do
      add :video, :string
    end
  end
end
