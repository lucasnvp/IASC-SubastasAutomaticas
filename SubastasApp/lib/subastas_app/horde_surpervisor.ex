defmodule SubastasApp.HordeSupervisor do
  use Horde.DynamicSupervisor

  def start_link(_) do
    opts = [
      strategy: :one_for_one,
      distribution_strategy: Horde.UniformQuorumDistribution
    ]
    Horde.DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(init_arg) do
    [members: members()]
    |> Keyword.merge(init_arg)
    |> Horde.DynamicSupervisor.init()
  end

  def start_child(child_spec) do
    Horde.DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  defp members() do
    Enum.map([Node.self() | Node.list()], &{__MODULE__, &1})
  end

  def add_buyer(id, name, ip, tags) do
    IO.puts "********* start_child Buyer.Supervisor *********"

    spec = {SubastasApp.Buyer, {id, name, ip, tags}}
    Horde.DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def add_bid(id, defaultPrice, duration, tags, item) do
    IO.puts "********* start_child Bid.Supervisor *********"

    spec = {SubastasApp.Bid, {id, defaultPrice, duration, tags, item}}
    Horde.DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
