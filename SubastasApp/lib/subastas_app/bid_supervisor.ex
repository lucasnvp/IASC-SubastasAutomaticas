defmodule SubastasApp.BidSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_bid(id, defaultPrice, duration, tags, item) do
    IO.puts "********* start_child Bid.Supervisor *********"

    spec = {SubastasApp.Bid, {id, defaultPrice, duration, tags, item}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
