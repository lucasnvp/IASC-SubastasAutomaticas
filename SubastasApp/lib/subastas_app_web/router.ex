defmodule SubastasAppWeb.Router do
  use SubastasAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SubastasAppWeb do
    pipe_through :api

    post "/buyers", BuyerController, :create
    post "/buyers_bid", BuyerController, :bid
    get "/buyers/get", BuyerController, :get_buyers

    post "/bids", BidController, :create
    post "/bids_received", BidController, :bid_received

  end
end
