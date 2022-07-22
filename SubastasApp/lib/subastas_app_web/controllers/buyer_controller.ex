defmodule SubastasAppWeb.BuyerController do
  use SubastasAppWeb, :controller
  alias SubastasAppWeb.BuyerModel
  alias SubastasAppWeb.OfferModel

  def create(conn, %{"name" => name, "ip" => ip, "tags" => tags_str}) do
    id = UUID.uuid4()
    tags = String.split(tags_str, ", ")
    SubastasApp.HordeSupervisor.add_buyer(id, name, ip, tags)

    conn
    |> put_status(200)
    |> text("Comprador registrado")
  end

  def offer(conn, %{"userId" => user_id, "bidId" => bid_id, "price" => price}) do
    offer = %{
      user_id: user_id,
      bid_id: bid_id,
      price: price,
      ts: :calendar.universal_time()
    }

    buyer_pids = Horde.Registry.lookup(SubastasApp.HordeRegistry, user_id)
    IO.inspect buyer_pids, label: "Buyer pid is"

    bid_pids = Horde.Registry.lookup(SubastasApp.HordeRegistry, bid_id)
    IO.inspect bid_pids, label: "Bid pid is"

    if(bid_pids !== []) do
      if(buyer_pids !== []) do

        # Check price
        bid_price = bid_pids |> Enum.at(0) |> elem(1) |> elem(1)
        if (bid_price < offer.price) do
          bid_pid = bid_pids |> Enum.at(0) |> elem(0)
          message = GenServer.call(bid_pid, {:new_offer, offer})
          conn
          |> put_status(200)
          |> text(message)
        else
          conn
          |> put_status(200)
          |> text("Oferta invalida - low price")
        end

      else
        conn
          |> put_status(200)
          |> text("Buyer not registered!")
      end
    else
      conn
        |> put_status(200)
        |> text("Bid not registered!")
    end
  end

  def get_buyers(conn, %{}) do
    buyers = Memento.transaction! fn ->
      Memento.Query.all(BuyerModel)
    end
    IO.inspect buyers, label: "The buyers are"

    render(conn, "list.json", buyers: buyers)
  end
end
