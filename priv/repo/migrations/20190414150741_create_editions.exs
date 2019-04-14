defmodule Eurovision2019.Repo.Migrations.CreateEditions do
  use Ecto.Migration

  def change do
    create table(:editions) do
      add :year, :string

      timestamps()
    end

    create unique_index(:editions, [:year])
  end
end
