defmodule SubastasAppWeb.Bid do
  use Memento.Table,
      attributes: [:tags, :defaultPrice, :duration, :item],
      type: :ordered_set,
      autoincrement: true
  
end
