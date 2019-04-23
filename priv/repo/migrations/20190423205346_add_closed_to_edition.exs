defmodule Eurovision2019.Repo.Migrations.AddClosedToEdition do
  use Ecto.Migration

  def change do
    alter table(:editions) do
      add :closed, :boolean, default: false
    end
  end
end
