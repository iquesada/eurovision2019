defmodule Eurovision2019Web.PageView do
  use Eurovision2019Web, :view

  alias Eurovision2019.Assets

  def photo_url(participant), do: Assets.public_participant_photo_url(participant)

  def get_points(%{id: participant_id}, votes) do
    case Enum.find(votes, :error, fn {id, _points} -> id == participant_id end) do
      :error -> 0
      {_participant_id, points} -> points
    end
  end
end
