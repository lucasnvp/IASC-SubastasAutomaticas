defmodule SubastasAppWeb.Router do
  use SubastasAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SubastasAppWeb do
    pipe_through :api
  end
end
