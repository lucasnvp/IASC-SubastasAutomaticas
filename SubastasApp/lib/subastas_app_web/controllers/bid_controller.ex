defmodule SubastasAppWeb.BidController do
  use SubastasAppWeb, :controller
  alias SubastasAppWeb.Bid
  alias SubastasAppWeb.Buyer

  def create(conn, %{"tags" => tags, "defaultPrice" => defaultPrice, "duration" => duration, "item" => item}) do
    IO.puts "Buyer #{item} - init"

    # Write a record
    operation = fn ->
      Memento.Query.write(%Bid{tags: tags, defaultPrice: defaultPrice, duration: duration, item: item})
    end
    Memento.Transaction.execute_sync(operation, 5)

#    todo filtrar por intereses
    buyers = Memento.transaction! fn ->
      Memento.Query.all(Buyer)
    end
#    IO.inspect buyers, label: "The buyers are"
#    todo enviar a todos los compradores wip
    url = "http://localhost:4000/api/buyers/bid_notifier"
    {:noreply, response} = HTTPoison.post url, "{\"body\": \"test\"}", [{"Content-Type", "application/json"}]

    conn
    |> put_status(200)
    |> text("Item registrado")
  end

end
