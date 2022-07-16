defmodule SubastasAppWeb.Bid do
  use Memento.Table,
      attributes: [:id, :tags, :defaultPrice, :duration, :item],
      type: :ordered_set,
      autoincrement: true
  
end
