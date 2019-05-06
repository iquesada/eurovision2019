defmodule Eurovision2019Web.EditionView do
  use Eurovision2019Web, :view

  alias Eurovision2019.Assets

  def get_winner([winner | _]), do: winner

  def photo_url(participant), do: Assets.public_participant_photo_url(participant)

  def get_points(%{id: participant_id}, votes) do
    Enum.find(votes, 0, fn {id, _points} -> id == participant_id end)
  end
end
