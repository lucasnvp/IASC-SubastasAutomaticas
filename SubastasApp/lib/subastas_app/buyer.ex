defmodule SubastasApp.Buyer do
  use GenServer
  alias SubastasAppWeb.BuyerModel

  def start_link({id, name, ip, tags}) do
    GenServer.start_link(__MODULE__, {id, name, ip, tags})
  end

  def child_spec({id, name, ip, tags}) do
    %{id: id, start: {__MODULE__, :start_link, [{id, name, ip, tags}]}, type: :worker}
  end

  def init({id, name, ip, tags}) do
    IO.puts "Buyer #{name} - init"

    operation = fn ->
      Memento.Query.write(%BuyerModel {id: id, pid: self(), timestamp: :calendar.universal_time(), name: name, ip: ip, tags: tags})
    end
    Memento.Transaction.execute_sync(operation, 5)

    {:ok, %{:id => id, :name => name, :ip => ip ,:tags => tags }}
  end

  def handle_cast({:new_bid, bid}, state) do
    IO.inspect state, label: "Buyer notifies new bid to endpoint"
    url = "http://localhost:4000/api/#{state[:id]}/new_bid"
    HTTPoison.post url, Jason.encode(bid), [{"Content-Type", "application/json"}]
    {:noreply, state}
  end
end
