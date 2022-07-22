defmodule SubastasAppWeb.BidController do
  use SubastasAppWeb, :controller

  def create(conn, %{"tags" => tags_str, "defaultPrice" => defaultPrice, "duration" => duration, "item" => item}) do
    id = UUID.uuid4()
    tags = String.split(tags_str, ", ")
    SubastasApp.HordeSupervisor.add_bid(id, defaultPrice, duration, tags, item)

    conn
    |> put_status(200)
    |> text("Item registrado")
  end
end
