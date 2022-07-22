defmodule SubastasAppWeb.BuyerModel do
  use Memento.Table,
    attributes: [:id, :pid, :timestamp, :name, :ip, :tags],
    type: :ordered_set,
    autoincrement: true
end
