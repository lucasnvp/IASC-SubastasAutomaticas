defmodule SubastasAppWeb.BidController do
  use SubastasAppWeb, :controller

  def create(conn, %{"tags" => tags, "defaultPrice" => defaultPrice, "duration" => duration, "item" => item}) do
    id = UUID.uuid4()
    tags_list = String.split(", ")
    SubastasApp.HordeSupervisor.add_bid(id, defaultPrice, duration, tags_list, item)

    conn
    |> put_status(200)
    |> text("Item registrado")
  end
end
