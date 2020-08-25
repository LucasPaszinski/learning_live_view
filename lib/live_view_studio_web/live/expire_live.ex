defmodule LiveViewStudioWeb.ExpireLive do
  use LiveViewStudioWeb, :live_view
  use Timex

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000,:tick)
    end

    expiration_time = Timex.shift(Timex.now(), hours: 1)

    socket =
      assign(
        socket,
        time_remaining: time_remaining(expiration_time) ,
        expire_time: expiration_time
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Remaining Time <%= @time_remaining %></h1>
    """
  end

  def handle_info(:tick, socket) do
    socket =
      assign(
        socket,
        time_remaining: time_remaining(socket.assigns.expire_time)
      )
    {:noreply, socket}
  end

  defp time_remaining(expiration_time) do
    Timex.Interval.new(from: Timex.now(), until: expiration_time)
    |> Timex.Interval.duration(:seconds)
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end
end
