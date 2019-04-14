defmodule Eurovision2019.Repo.Migrations.AddPhotoToParticipants do
  use Ecto.Migration

  def change do
    alter table(:participants) do
      add :photo, :string
    end
  end
end
