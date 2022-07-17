defmodule SubastasAppWeb.Bids do
  use Memento.Table,
      attributes: [:id, :user_id, :bid_id, :price, :ts],
      type: :ordered_set,
      autoincrement: true

end
