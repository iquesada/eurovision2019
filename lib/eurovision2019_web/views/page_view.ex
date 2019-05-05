defmodule Eurovision2019Web.PageView do
  use Eurovision2019Web, :view

  def get_points(%{id: participant_id}, votes) do
    case Enum.find(votes, :error, fn {id, _points} -> id == participant_id end) do
      :error -> 0
      {_participant_id, points} -> points
    end
  end
end
