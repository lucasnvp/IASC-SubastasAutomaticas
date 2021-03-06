defmodule SubastasApp.BuyerNotifier do
  use GenServer
	alias SubastasAppWeb.BuyerModel
	alias SubastasAppWeb.OfferModel

	def start_link(_state) do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def child_spec() do
    %{start: {__MODULE__, :start_link, []}, type: :worker}
  end

	def init(init_arg) do
		{:ok, init_arg}
	end

	def handle_cast({:new_bid, bid}, state) do
		buyers = get_buyers()
		Enum.each(buyers, fn buyer -> GenServer.cast(buyer.pid, {:new_bid, bid}) end)
		{:noreply, state}
	end

	def handle_cast({:new_bid_price, offer, bid}, state) do
		buyers = get_buyers()
		Enum.each(buyers, fn buyer -> GenServer.cast(buyer.pid, {:new_bid_price, offer, bid}) end)
		{:noreply, state}
	end

	def handle_cast({:bid_cancellation, bid}, state) do
		# TODO: informar a subscriptores a esta subastas
		buyers = get_buyers()

		# Buscar en el registry
		Enum.each(buyers, fn buyer -> GenServer.cast(buyer.pid, {:bid_cancellation, bid}) end)
		{:noreply, state}
	end

	def handle_cast({:bid_ending, bid}, state) do
		offers = Memento.transaction! fn ->
      Memento.Query.select(OfferModel, {:==,:bid_id, bid.id})
    end

    offer = Enum.max_by(offers, fn offer -> offer.price end)

		buyers = get_buyers()
			Enum.each(buyers, fn buyer -> GenServer.cast(buyer.pid, {:bid_ending, offer, bid}) end)
		{:noreply, state}
	end

	defp get_buyers() do
		buyers = Memento.transaction! fn ->
      Memento.Query.all(BuyerModel)
    end
		IO.inspect buyers, label: "The buyers are"
		buyers
	end
end
