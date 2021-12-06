defmodule LiveViewTodoWeb.PageLive do
  use LiveViewTodoWeb, :live_view
  alias LiveViewTodo.Item

  @topic "live"

  @impl true
  def mount(_params, _session, socket) do
    # IO.inspect(connected?(socket),label: "------------mount------------")
    if connected?(socket), do: LiveViewTodoWeb.Endpoint.subscribe(@topic)
    # if connected?(socket), do: Phoenix.PubSub.subscribe(LiveViewTodo.PubSub, @topic)
    {:ok, assign(socket, items: list_items())}
  end

  def handle_event("create", %{"text" => text}, socket) do
    # IO.inspect("", label: "++++create++++")
    Item.create_item(%{text: text})
    socket = assign(socket, items: list_items(), active: %Item{})
    LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    # Phoenix.PubSub.broadcast(LiveViewTodo.PubSub, @topic, {:add_item, socket.assigns.items})
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle", data, socket) do
    status = if Map.has_key?(data, "value"), do: 1, else: 0
    item = Item.get_item!(Map.get(data, "id"))
    Item.update_item(item, %{id: item.id, status: status})
    socket = assign(socket, items: list_items(), active: %Item{})
    LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, socket}
  end

  @impl true

  def handle_event("delete", data, socket) do
    Map.get(data, "id") |> Item.delete_item()
    socket = socket |> assign(items: list_items(), active: %Item{})
    LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, socket}
  end

  @impl true
  def handle_info(data, socket) do
    # IO.inspect("", label: "++++handle_info++++")
    {:noreply, assign(socket, :items, data.payload.items)}
  end

  def list_items do
    Item.list_items()
    |> Enum.filter(fn %{status: status} ->
      status != 2
    end)
  end
end
