defmodule Chat.RoomChannel do
  use Chat.Web, :channel

  def join("rooms:lobby", %{"name" => name}, socket) do
    case Chat.LoginUser.login(socket.channel_pid, name) do
      :ok ->
        messages = Chat.Message.get |> Enum.map(fn {user, body} -> %{user: user, body: body} end)
        {:ok, %{messages: messages}, socket}
      :error -> {:error, %{}}
    end
  end

  def terminate(_reason, socket) do
    Chat.LoginUser.logout(socket.channel_pid)
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    user = Chat.LoginUser.user(socket.channel_pid)
    Chat.Message.add(user, body)
    broadcast! socket, "new_msg", %{user: user, body: body}
    {:noreply, socket}
  end
end
