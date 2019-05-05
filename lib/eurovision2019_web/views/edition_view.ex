defmodule Eurovision2019Web.EditionView do
  use Eurovision2019Web, :view

  def get_points(%{id: participant_id}, votes) do
    Enum.find(votes, 0, fn {id, points} -> id == participant_id end)
  end
end
