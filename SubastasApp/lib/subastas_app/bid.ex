defmodule SubastasApp.Bid do
  use GenServer
  alias SubastasAppWeb.BidModel

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def child_spec({id, defaultPrice, duration, tags, item}) do
    %{id: id, start: {__MODULE__, :start_link, [{id, defaultPrice, duration, tags, item}]}, type: :worker}
  end

  def init({id, defaultPrice, duration, tags, item}) do
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

    # Write a record
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

    notifier = Process.whereis(SubastasApp.BuyerNotifier)
    IO.inspect notifier, label: "Notifier: "
    GenServer.cast(notifier,{:new_bid, bid})

    {:ok, %{:id => id, :tags => tags, :defaultPrice => defaultPrice, :duration => duration, :item => item}}
  end
end
