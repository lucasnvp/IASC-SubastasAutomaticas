defmodule SubastasApp.BuyerNotifier do
  use GenServer
	alias SubastasAppWeb.BuyerModel

	def start_link(state) do
		GenServer.start_link(__MODULE__, [], state)
	end

	def child_spec() do
    %{start: {__MODULE__, :start_link, []}, type: :worker}
  end

	def init() do
		{:ok, %{}}
	end

	def getBuyers() do
		buyers = Memento.transaction! fn ->
      Memento.Query.all(BuyerModel)
    end
		IO.inspect buyers, label: "The buyers are"
		buyers
	end

	def handle_cast({:notify_new_bid, bid}, state) do
		Enum.each(SubastasApp.BuyerNotifier.getBuyers(), fn buyer -> GenServer.cast(buyer.pid,{:notify_new_bid, bid}) end)
		{:noreply, state}
	end

	def handle_cast({:notify_new_price, bid}, state) do
		Enum.each(SubastasApp.BuyerNotifier.getBuyers(), fn buyer -> GenServer.cast(buyer,{:notify_new_price, bid}) end)
		{:noreply, state}
	end

	def handle_cast({:notify_cancelation, bid}, state) do
		Enum.each(SubastasApp.BuyerNotifier.getBuyers(), fn buyer -> GenServer.cast(buyer,{:notify_cancelation, bid}) end)
		{:noreply, state}
	end

	def handle_cast({:notify_ending, bid}, state) do
		Enum.each(SubastasApp.BuyerNotifier.getBuyers(), fn buyer -> GenServer.cast(buyer,{:notify_ending, bid}) end)
		{:noreply, state}
	end

end
