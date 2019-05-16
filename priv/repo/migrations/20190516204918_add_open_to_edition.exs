defmodule Eurovision2019.Repo.Migrations.AddOpenToEdition do
  use Ecto.Migration

  def change do
    alter table(:editions) do
      add :open, :boolean, default: false
    end
  end
end
