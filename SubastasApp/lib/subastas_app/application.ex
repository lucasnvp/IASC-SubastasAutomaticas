defmodule SubastasApp.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    other_nodes = get_cluster_hosts()
    IO.inspect other_nodes, label: "Other nodes"

    # Setup Memento
    Memento.start()

    if (length(other_nodes) > 0) do
      Memento.add_nodes(other_nodes)
    else
      Memento.Table.create!(SubastasAppWeb.BuyerModel)
      Memento.Table.create!(SubastasAppWeb.BidModel)
      Memento.Table.create!(SubastasAppWeb.BidSubmissionModel)
    end

    topologies = [
      SubastasApp: [
        strategy: Cluster.Strategy.Epmd,
        config: [
          hosts: other_nodes
        ]
      ]
    ]

    # Define workers and child supervisors to be supervised
    children = [
      {Cluster.Supervisor, [topologies, [name: SubastasApp.ClusterSupervisor]]},
      # Start the endpoint when the application starts
      SubastasAppWeb.Endpoint,
      SubastasApp.BuyerNotifier,
      SubastasApp.HordeRegistry,
      SubastasApp.HordeSupervisor,
      # Start your own worker by calling: SubastasApp.Worker.start_link(arg1, arg2, arg3)
      # worker(SubastasApp.Worker, [arg1, arg2, arg3]),
      {Phoenix.PubSub, [name: SubastasApp.PubSub, adapter: Phoenix.PubSub.PG2]},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SubastasApp.Supervisor]
    Supervisor.start_link(children, opts)

  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SubastasAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp get_cluster_hosts() do
    case :inet.gethostbyname(:app) do
      {:ok, {:hostent, 'app', [], :inet, 4, hosts_ip}} ->
        hosts = Enum.map(hosts_ip, fn ip ->
          {:ok, {:hostent, hostname, [], :inet, 4, _ips}} = :inet.gethostbyaddr(ip)

          String.to_atom("node@" <> normalize_hostname(hostname))
        end)
        Enum.filter(hosts, fn host -> host != node() end)

      error ->
        raise "Unexpected #{inspect(error)}"
    end
  end

  defp normalize_hostname(hostname) do
    hostname
    |> to_string()
    |> String.split(".subastas-net")
    |> List.first()
  end
end
