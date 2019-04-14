defmodule Eurovision2019.Repo.Migrations.RemoveUsers do
  use Ecto.Migration

  def change do
    drop table(:users)
  end
end
