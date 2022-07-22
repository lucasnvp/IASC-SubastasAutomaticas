defmodule SubastasApp.Bid do
  use GenServer
  alias SubastasAppWeb.BidModel
  alias SubastasAppWeb.OfferModel

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def child_spec({id, defaultPrice, duration, tags, item}) do
    %{id: id, start: {__MODULE__, :start_link, [{id, defaultPrice, duration, tags, item}]}, type: :worker}
  end

  def init({id, defaultPrice, duration, tags, item}) do
    # Process.send_after(self(), :end_bid, duration*1000)
    Horde.Registry.register(SubastasApp.HordeRegistry, id, {id, defaultPrice, duration, tags, item})
    IO.puts "Bid #{item} - init"

    bid = %{
      id: id,
      pid: self(),
      timestamp: :calendar.universal_time(),
      tags: tags,
      defaultPrice: defaultPrice,
      duration: duration,
      item: item
    }

    operation = fn ->
      Memento.Query.write(%BidModel{
        id: bid.id,
        pid: bid.pid,
        timestamp: bid.timestamp,
        tags: bid.tags,
        defaultPrice: bid.defaultPrice,
        duration: bid.duration,
        item: bid.item
      })
    end
    Memento.Transaction.execute_sync(operation, 5)

    # Always calls the buyer notifier from the node where the bid was instantiated
    notifier = Process.whereis(SubastasApp.BuyerNotifier)
    IO.inspect notifier, label: "Notifier about to notify new bid: "
    GenServer.cast(notifier, {:new_bid, bid})

    {:ok, %{:id => id, :tags => tags, :defaultPrice => defaultPrice, :duration => duration, :item => item}}
  end

  def handle_call({:new_offer, offer}, _from, state) do
    IO.inspect offer, label: "New offer received"

    operation = fn ->
      Memento.Query.select(OfferModel, {:==,:bid_id, offer.bid_id})
    end
    offers = Memento.Transaction.execute_sync(operation, 5)

    max_offer = Enum.max_by(offers, fn offer -> offer.price end)
    if(offer.price <= max_offer.price) do
      {:reply, "Low offer", state}
    else
      notifier = Process.whereis(SubastasApp.BuyerNotifier)
      IO.inspect notifier, label: "Notifier about to notify new bid price: "
      GenServer.cast(notifier, {:new_bid_price, max_offer})

      {:reply, "New max offer!", state}
    end
  end

  def handle_cast(:end_bid, state) do
    notifier = Process.whereis(SubastasApp.BuyerNotifier)
    IO.inspect notifier, label: "Notifier about to notify bid ending: "
    GenServer.cast(notifier, {:bid_ending, state})

    Process.exit(self(), :shutdown)
    {:noreply, state}
  end
end
