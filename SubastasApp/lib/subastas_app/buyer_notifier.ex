defmodule SubastasApp.BuyerNotifier do
  use GenServer
	alias SubastasAppWeb.BuyerModel

	def start_link(_state) do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def child_spec() do
    %{start: {__MODULE__, :start_link, []}, type: :worker}
  end

	def init(init_arg) do
		{:ok, init_arg}
	end

	def getBuyers() do
		buyers = Memento.transaction! fn ->
      Memento.Query.all(BuyerModel)
    end
		IO.inspect buyers, label: "The buyers are"
		buyers
	end

	def handle_cast({:new_bid, bid}, state) do
		Enum.each(SubastasApp.BuyerNotifier.getBuyers(), fn buyer -> GenServer.cast(buyer.pid,{:new_bid, bid}) end)
		{:noreply, state}
	end

	def handle_cast({:new_bid_price, bid}, state) do
		Enum.each(SubastasApp.BuyerNotifier.getBuyers(), fn buyer -> GenServer.cast(buyer,{:new_bid_price, bid}) end)
		{:noreply, state}
	end

	def handle_cast({:bid_cancelation, bid}, state) do
		Enum.each(SubastasApp.BuyerNotifier.getBuyers(), fn buyer -> GenServer.cast(buyer,{:bid_cancelation, bid}) end)
		{:noreply, state}
	end

	def handle_cast({:bid_ending, bid}, state) do
		Enum.each(SubastasApp.BuyerNotifier.getBuyers(), fn buyer -> GenServer.cast(buyer,{:bid_ending, bid}) end)
		{:noreply, state}
	end
end
