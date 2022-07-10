defmodule SubastasAppWeb.BidController do
  use SubastasAppWeb, :controller
  use Memento.Table,
      attributes: [:tags, :defaultPrice, :duration, :item],
      type: :ordered_set,
      autoincrement: true

  def create(conn, %{"tags" => tags, "defaultPrice" => defaultPrice, "duration" => duration, "item" => item}) do
    IO.puts "Buyer #{item} - init"

    # Write a record
    operation = fn ->
      Memento.Query.write(%SubastasAppWeb.BidController{tags: tags, defaultPrice: defaultPrice, duration: duration, item: item})
    end
    Memento.Transaction.execute_sync(operation, 5)


    conn
    |> put_status(200)
    |> text("Item registrado")
  end

end
