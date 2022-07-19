defmodule SubastasAppWeb.BuyerController do
  use SubastasAppWeb, :controller
  alias SubastasAppWeb.BuyerModel
  alias SubastasAppWeb.BidSubmissionModel

  def create(conn, %{"name" => name, "ip" => ip, "tags" => tags}) do
    id = UUID.uuid4()
    SubastasApp.BuyerSupervisor.add_buyer(id, name, ip, tags)

    conn
    |> put_status(200)
    |> text("Comprador registrado")
  end

  def bid(conn, %{"userId" => userId, "bidId" => bidId, "price" => price}) do
    IO.puts "Oferta realizada from user: #{userId} -Bid: Id: #{bidId} - Price: #{price}"

#    bid = Memento.transaction! fn ->
#      Memento.Query.read(Bid, String.to_integer(bidId))
#    end
#    IO.inspect bid

#    todo   validar los ids

    # Write a record
    operation = fn ->
      Memento.Query.write(%BidSubmissionModel {
        user_id: userId,
        bid_id: bidId,
        price: price,
        ts: NaiveDateTime.utc_now,
      })
    end
    Memento.Transaction.execute_sync(operation, 5)

    conn
    |> put_status(200)
    |> text("Bid realizada")
  end

  def get_buyers(conn, %{}) do
    buyers = Memento.transaction! fn ->
      Memento.Query.all(BuyerModel)
    end
    IO.inspect buyers, label: "The buyers are"

    render(conn, "list.json", buyers: buyers)
  end

  def bid_notification(conn, %{}) do
    IO.puts "Nueva oferta realizada"

    conn
    |> Plug.Conn.send_resp(200, [])
    |> Plug.Conn.halt()
  end
end
