defmodule LiveItem do
  use LiveViewTodoWeb, :live_component

  def render(assigns) do
    ~H"""
      <li data-id={@item.id} class={completed?(@item)}>
        <div class="view">
          <%= if checked?(@item) do%>
          <input class="toggle" type="checkbox" phx-value-id={@item.id} phx-click="toggle" checked/>
          <% else %>
          <input class="toggle" type="checkbox" phx-value-id={@item.id} phx-click="toggle"/>
          <% end %>
          <label><%= @item.text %></label>
          <button class="destroy" phx-click="delete" phx-value-id={@item.id}></button>
        </div>
      </li>
    """
  end

  def completed?(item) do
    if not is_nil(item.status) and item.status > 0, do: "completed", else: ""
  end

  def checked?(item) do
    not is_nil(item.status) and
      item.status > 0
  end
end
