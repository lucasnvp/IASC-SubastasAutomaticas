defmodule SubastasAppWeb.Router do
  use SubastasAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SubastasAppWeb do
    pipe_through :api

    get "/buyers", BuyerController, :readDB
    post "/buyers", BuyerController, :create
    post "/bids", BidController, :create

  end
end
