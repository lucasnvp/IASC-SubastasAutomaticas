defmodule SubastasAppWeb.BuyerView do
  use SubastasAppWeb, :view

  def render("list.json", %{buyers: buyers}) do
    Enum.map(buyers, fn buyer -> render("buyer.json", buyer) end)
  end

  def render("buyer.json", buyer) do
    %{name: buyer.name,
      ip: buyer.ip,
      tags: buyer.tags}
  end
  
end
