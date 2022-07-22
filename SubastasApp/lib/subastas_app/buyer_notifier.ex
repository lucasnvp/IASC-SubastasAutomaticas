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

	def handle_cast({:new_bid_price, max_offer}, state) do
		operation = fn ->
      Memento.Query.select(OfferModel, [{:==,:bid_id, max_offer.bid_id}, {:!=, :user_id, max_offer.user_id}])
    end
    other_buyers_offers = Memento.Transaction.execute_sync(operation, 5)

		Enum.each(other_buyers_offers, fn offer ->
			{buyer_pid, _} = Horde.Registry.lookup(SubastasApp.HordeRegistry, offer.user_id)
			GenServer.cast(buyer_pid,{:new_bid_price, max_offer})
		end)
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

    max_offer = Enum.max_by(offers, fn offer -> offer.price end)

    {max_offer_buyer, _} = Horde.Registry.lookup(SubastasApp.HordeRegistry, max_offer.user_id)
		GenServer.cast(max_offer_buyer, {:bid_ending_won, bid})

		other_buyers_offers = Enum.filter(offers, fn offer -> offer !== max_offer end)

		Enum.each(other_buyers_offers, fn offer ->
			{buyer_pid, _} = Horde.Registry.lookup(SubastasApp.HordeRegistry, offer.user_id)
			GenServer.cast(buyer_pid, {:bid_ending_lost, bid})
		end)
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
