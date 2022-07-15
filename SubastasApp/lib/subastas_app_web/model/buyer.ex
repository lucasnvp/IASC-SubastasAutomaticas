defmodule SubastasAppWeb.Buyer do
  use Memento.Table,
      attributes: [:name, :ip, :tags]

#  @derive {Jason.Encoder, only: [:name, :ip]}

end
