defmodule SubastasAppWeb.BuyerController do
  use SubastasAppWeb, :controller
  use Memento.Table,
      attributes: [:name, :ip, :tags],
      type: :ordered_set,
      autoincrement: true

  def create(conn, %{"name" => name, "ip" => ip, "tags" => tags}) do
    IO.puts "Buyer #{name} - init"

    # Write a record
    operation = fn ->
      Memento.Query.write(%SubastasAppWeb.BuyerController{name: name, ip: ip, tags: tags})
    end
    Memento.Transaction.execute_sync(operation, 5)

    conn
    |> put_status(200)
    |> text("Comprador registrado")
  end
end
