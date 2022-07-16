defmodule SubastasAppWeb.BuyerController do
  use SubastasAppWeb, :controller
  alias SubastasAppWeb.Buyer
  alias SubastasAppWeb.Bid

  def create(conn, %{"name" => name, "ip" => ip, "tags" => tags}) do
    IO.puts "Buyer #{name} - init"

    # Write a record
    operation = fn ->
      Memento.Query.write(%Buyer{name: name, ip: ip, tags: tags})
    end
    Memento.Transaction.execute_sync(operation, 5)

    conn
    |> put_status(200)
    |> text("Comprador registrado")
  end

  def bid(conn, %{"id" => id, "price" => price}) do
    IO.puts "Oferta realizada"
    IO.puts "Id: #{id} - Price: #{price}"

    bids = Memento.transaction! fn ->
      Memento.Query.all(Bid)
    end
    IO.inspect bids, label: "The bids are"

#    time = NaiveDateTime.utc_now
    bid = Memento.transaction! fn ->
#      Memento.Query.read(Bid, Integer.parse(id))
      Memento.Query.read(Bid, id)
    end
    IO.puts "Bid: #{bid}"

    conn
    |> put_status(200)
    |> text("Bid realizada")
  end

  def get_buyers(conn, %{}) do
    buyers = Memento.transaction! fn ->
      Memento.Query.all(Buyer)
    end
    IO.inspect buyers, label: "The buyers are"

    render(conn, "list.json", buyers: buyers)
  end
end
