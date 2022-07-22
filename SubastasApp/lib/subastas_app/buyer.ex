defmodule SubastasApp.Buyer do
  use GenServer
  alias SubastasAppWeb.BuyerModel

  # Buyer Server
  def start_link({id, name, ip, tags}) do
    GenServer.start_link(__MODULE__, {id, name, ip, tags})
  end

  def child_spec({id, name, ip, tags}) do
    %{id: id, start: {__MODULE__, :start_link, [{id, name, ip, tags}]}, type: :worker}
  end

  def init({id, name, ip, tags}) do
    Horde.Registry.register(SubastasApp.HordeRegistry, id, {id, name, ip, tags})
    IO.puts "Buyer #{name} - init"

    operation = fn ->
      Memento.Query.write(%BuyerModel {id: id, pid: self(), timestamp: :calendar.universal_time(), name: name, ip: ip, tags: tags})
    end
    Memento.Transaction.execute_sync(operation, 5)

    {:ok, %{:id => id, :name => name, :ip => ip ,:tags => tags }}
  end

  def handle_cast({:new_bid, bid}, state) do
    IO.inspect state, label: "Buyer notifies new bid to endpoint"
    IO.inspect bid, label: "Bid"
    # url = "http://localhost:4000/api/#{state[:id]}/new_bid"
    # HTTPoison.post url, "New bid #{bid.id}"
    {:noreply, state}
  end

  def handle_cast({:new_bid_price, max_offer}, state) do
    IO.inspect state, label: "Buyer notifies new bid price to endpoint"
    IO.inspect max_offer, label: "Max offer"
    # url = "http://localhost:4000/api/#{state[:id]}/new_bid"
    # HTTPoison.post url, "New bid #{bid.id}"
    {:noreply, state}
  end

  def handle_cast({:bid_cancellation, bid}, state) do
    IO.inspect state, label: "Buyer notifies bid cancellation to endpoint"
    IO.inspect bid, label: "Bid"
    # url = "http://localhost:4000/api/#{state[:id]}/new_bid"
    # HTTPoison.post url, "New bid #{bid.id}"
    {:noreply, state}
  end

  def handle_cast({:bid_ending_lost, bid}, state) do
    IO.inspect state, label: "Buyer notifies bid ending to endpoint (LOST)"
    IO.inspect bid, label: "Bid"
    # url = "http://localhost:4000/api/#{state[:id]}/new_bid"
    # HTTPoison.post url, "New bid #{bid.id}"
    {:noreply, state}
  end

  def handle_cast({:bid_ending_won, bid}, state) do
    IO.inspect state, label: "Buyer notifies bid ending to endpoint (WIN)"
    IO.inspect bid, label: "Bid"
    # url = "http://localhost:4000/api/#{state[:id]}/new_bid"
    # HTTPoison.post url, "New bid #{bid.id}"
    {:noreply, state}
  end
end
