defmodule Eurovision2019Web.ParticipantView do
  use Eurovision2019Web, :view

  alias Eurovision2019.Assets

  def photo_url(participant), do: Assets.public_participant_photo_url(participant)

  def video(_), do: ""
end
