defmodule SubastasAppWeb.Buyer do
  use Memento.Table,
      attributes: [:id, :name, :ip, :tags],
      type: :ordered_set,
      autoincrement: true

#  @derive {Jason.Encoder, only: [:name, :ip]}

end
