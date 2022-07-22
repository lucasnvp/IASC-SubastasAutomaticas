defmodule SubastasAppWeb.Router do
  use SubastasAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SubastasAppWeb do
    pipe_through :api

    post "/buyers", BuyerController, :create
    post "/buyers/offer", BuyerController, :offer
    get "/buyers/", BuyerController, :get_buyers

    post "/bids", BidController, :create
  end
end
