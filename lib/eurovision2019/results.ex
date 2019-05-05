defmodule Eurovision2019.Results do
  @moduledoc false

  import Ecto.Query, warn: false

  alias Eurovision2019.{
    Editions.Edition,
    Participants.Participant,
    Repo,
    Results.Result
  }

  def get_result(%{id: edition_id}) do
    from(result in Result,
      preload: :participant,
      join: participant in Participant,
      where: result.participant_id == participant.id,
      join: edition in Edition,
      where: participant.edition_id == ^edition_id
    )
    |> Repo.all()
  end
end
