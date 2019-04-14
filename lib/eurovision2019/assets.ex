defmodule Eurovision2019.Assets do
  @moduledoc false

  alias Eurovision2019.Storage

  @id_interpolation "{id}"
  @file_interpolation "{file}"
  @participant_photo_url "participant/{id}/photo/{file}"

  def participant_photo_url(%{id: id}, file) do
    generate_url(Integer.to_string(id), file)
  end

  def public_participant_photo_url(%{photo: nil}), do: ""

  def public_participant_photo_url(%{id: id, photo: photo}) do
    generate_url(Integer.to_string(id), photo)
    |> Storage.public_url()
  end

  def public_participant_photo_url(), do: ""

  defp generate_url(id, file) do
    @participant_photo_url
    |> String.replace(@id_interpolation, id)
    |> String.replace(@file_interpolation, file)
  end
end
