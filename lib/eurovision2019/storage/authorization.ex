defmodule Eurovision2019.Storage.Authorization do
  @moduledoc false

  @googleapis_url "https://www.googleapis.com/auth/cloud-platform"

  def authorize do
    case Goth.Token.for_scope(@googleapis_url) do
      {:ok, token} -> {:ok, GoogleApi.Storage.V1.Connection.new(token.token)}
      error -> error
    end
  end
end
