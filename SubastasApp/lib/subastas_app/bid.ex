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
    Horde.Registry.register(SubastasApp.HordeRegistry, id, {id, defaultPrice, duration, tags, item})
    Process.send_after(self(), :end_bid, String.to_integer(duration) * 60000)
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

  def handle_call({:new_offer, offer}, _from, bid) do
    IO.inspect offer, label: "New offer received"

    # Write a record
    operation = fn ->
      Memento.Query.write(%OfferModel {
        user_id: offer.user_id,
        bid_id: offer.bid_id,
        timestamp: offer.ts,
        price: offer.price,
      })

      case Memento.Query.read(BidModel, bid.id, lock: :write) do
        %BidModel{} = bidModel ->
          bidModel
          |> struct(bid)
          |> Map.put(:defaultPrice, offer.price)
          |> Memento.Query.write()
          |> then(&{:ok, &1})

        nil ->
          {:error, :not_found}
      end

    end
    Memento.Transaction.execute_sync(operation, 5)

    notifier = Process.whereis(SubastasApp.BuyerNotifier)
    GenServer.cast(notifier, {:new_bid_price, offer, bid})

    {:reply, "Oferta realizada", bid}
  end

  def handle_info(:end_bid, bid) do
    notifier = Process.whereis(SubastasApp.BuyerNotifier)
    IO.inspect notifier, label: "Notifier about to notify bid ending: "
    GenServer.cast(notifier, {:bid_ending, bid})

    operation = fn ->
      Memento.Query.delete(BidModel, bid.id)
    end
    Memento.Transaction.execute_sync(operation, 5)

    Horde.Registry.unregister(SubastasApp.HordeRegistry, bid.id)
    {:noreply, bid}
  end

end
