defmodule SubastasApp.BuyerSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_buyer(id, name, ip, tags) do
    IO.puts "********* start_child Buyer.Supervisor *********"

    spec = {SubastasApp.Buyer, {id, name, ip, tags}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
