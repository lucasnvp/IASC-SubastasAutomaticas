defmodule SubastasAppWeb.OfferModel do
  use Memento.Table,
      attributes: [:id, :timestamp, :user_id, :bid_id, :price],
      type: :ordered_set,
      autoincrement: true
end
