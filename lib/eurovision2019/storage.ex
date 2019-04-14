defmodule Eurovision2019.Storage do
  @moduledoc false

  alias __MODULE__.Authorization

  @bucket_id "piedresybarro-eurovision"
  @storage_url "https://storage.googleapis.com/"

  def upload(original_file, remote_file) do
    with {:ok, conn} <- Authorization.authorize(),
         {:ok, _object} <-
           GoogleApi.Storage.V1.Api.Objects.storage_objects_insert_simple(
             conn,
             @bucket_id,
             "multipart",
             %{name: remote_file},
             original_file
           ) do
      :ok
    else
      error -> :error
    end
  end

  def delete(file) do
    with {:ok, conn} <- Authorization.authorize(),
         {:ok, _object} <-
           GoogleApi.Storage.V1.Api.Objects.storage_objects_delete(
             conn,
             @bucket_id,
             file
           ) do
      :ok
    else
      error -> :error
    end
  end

  def public_url(file) do
    Path.join(@storage_url <> @bucket_id, file)
  end
end
