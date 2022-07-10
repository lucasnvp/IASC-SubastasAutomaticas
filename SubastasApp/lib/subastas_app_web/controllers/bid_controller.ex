defmodule SubastasAppWeb.BidController do
  use SubastasAppWeb, :controller

  def create(conn, %{"name" => name}) do
    IO.puts "Buyer #{name} - init"
    conn
    |> put_status(200)
    |> text("ok")
  end

end
