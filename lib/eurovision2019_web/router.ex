defmodule Eurovision2019Web.Router do
  use Eurovision2019Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Eurovision2019Web do
    pipe_through :browser

    get "/", PageController, :index
    resources "/registrations", UserController, only: [:create, :new]
    get "/sign-in", SessionController, :new
    post "/sign-in", SessionController, :create
    delete "/sign-out", SessionController, :delete
    resources "/accounts", UserController
    resources "/participants", ParticipantController
    resources "/editions", EditionController
    get "/editions/:id/close", EditionController, :close
    get "/editions/:id/results", EditionController, :results
  end

  # Other scopes may use custom stacks.
  # scope "/api", Eurovision2019Web do
  #   pipe_through :api
  # end
end
