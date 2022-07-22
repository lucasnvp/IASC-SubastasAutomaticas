defmodule SubastasAppWeb.BidModel do
  use Memento.Table,
    attributes: [:id, :pid, :timestamp, :tags, :defaultPrice, :duration, :item],
    type: :ordered_set,
    autoincrement: true
end
