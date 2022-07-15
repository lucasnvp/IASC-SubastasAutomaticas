defmodule SubastasAppWeb.BuyerController do
  use SubastasAppWeb, :controller

  def create(conn, %{"name" => name, "ip" => ip, "tags" => tags}) do
    IO.puts "Buyer #{name} - init"

    # Write a record
    operation = fn ->
      Memento.Query.write(%SubastasAppWeb.Buyer{name: name, ip: ip, tags: tags})
    end
    Memento.Transaction.execute_sync(operation, 5)

    conn
    |> put_status(200)
    |> text("Comprador registrado")
  end

  def bid(conn, %{"id" => id, "price" => price}) do
    IO.puts "Oferta realizada"
    IO.puts "Id: #{id} - Price: #{price}"

#    todo

    conn
    |> put_status(200)
    |> text("Bid realizada")
  end

  def get_buyers(conn, %{}) do
    buyers = Memento.transaction! fn ->
      Memento.Query.all(SubastasAppWeb.Buyer)
    end
    IO.inspect buyers, label: "The buyers is"

    render(conn, "list.json", buyers: buyers)
  end
end
