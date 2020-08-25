defmodule LiveViewStudioWeb.SalesDashLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    if connected?(socket),
      do: :timer.send_interval(1000, self(), :tick)

    socket = socket |> assign_update_dashboard

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Time Remaning: <%= @timer_remain %></h1>
    <h1>Sales: <%= @sales %> </h1>
    <h1>Sales <%= @amount %></h1>
    <h1>Satisfaction: <%= @satisfaction %></h1>
    <button phx-click="refresh">Refresh</button>

    """
  end

  def handle_event("refresh", _, socket) do
    socket = socket |> assign_update_dashboard()
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    socket = assign_update_dashboard(socket)
    {:noreply, socket}
  end

  defp assign_update_dashboard(socket) do
    assign(
        socket,
        sales: Sales.new_orders,
        amount: Sales.sales_amount,
        satisfaction: Sales.satisfaction
      )
  end
end
