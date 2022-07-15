defmodule SubastasAppWeb.BidController do
  use SubastasAppWeb, :controller

  def create(conn, %{"tags" => tags, "defaultPrice" => defaultPrice, "duration" => duration, "item" => item}) do
    IO.puts "Buyer #{item} - init"

    # Write a record
    operation = fn ->
      Memento.Query.write(%SubastasAppWeb.Bid{tags: tags, defaultPrice: defaultPrice, duration: duration, item: item})
    end
    Memento.Transaction.execute_sync(operation, 5)

    buyers = Memento.transaction! fn ->
      Memento.Query.all(SubastasAppWeb.Buyer)
    end

    IO.inspect buyers, label: "The buyers is"

    conn
    |> put_status(200)
    |> text("Item registrado")
  end

  def bid_received(conn) do
    IO.puts "Oferta recibida"

#    todo

    conn
    |> put_status(200)
    |> text("Oferta recibida")

  end

end
