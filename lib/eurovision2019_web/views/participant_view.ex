defmodule Eurovision2019Web.ParticipantView do
  use Eurovision2019Web, :view

  alias Eurovision2019.{Assets, Editions}

  def photo_url(participant), do: Assets.public_participant_photo_url(participant)

  def video(_), do: ""

  def editions(), do: Editions.list_editions() |> Enum.map(&{&1.year, &1.id})
end
