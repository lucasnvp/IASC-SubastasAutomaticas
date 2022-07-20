defmodule SubastasApp.Bid do
  use GenServer
  alias SubastasAppWeb.BuyerModel
  alias SubastasAppWeb.BidModel

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def child_spec({id, defaultPrice, duration, tags, item}) do
    %{id: id, start: {__MODULE__, :start_link, [{id, defaultPrice, duration, tags, item}]}, type: :worker}
  end

  def init({id, defaultPrice, duration, tags, item}) do
    IO.puts "Bid #{item} - init"

    # Write a record
    operation = fn ->
      Memento.Query.write(%BidModel{id: id, pid: self(), timestamp: :calendar.universal_time(), tags: tags, defaultPrice: defaultPrice, duration: duration, item: item})
    end
    Memento.Transaction.execute_sync(operation, 5)

    #todo filtrar por intereses
    buyers = Memento.transaction! fn ->
      Memento.Query.all(BuyerModel)
    end

    IO.inspect buyers, label: "The buyers are"
    Enum.each(buyers, fn buyer ->
      GenServer.cast(buyer.pid, {:new_bid, self()})
    end)

    {:ok, %{:id => id, :tags => tags, :defaultPrice => defaultPrice, :duration => duration, :item => item}}
  end
end
