defmodule Chat.RoomChannel do
  use Chat.Web, :channel

  def join("rooms:lobby", %{"name" => name}, socket) do
    case Chat.LoginUser.login(socket.channel_pid, name) do
      :ok -> {:ok, socket}
      :error -> {:error, %{}}
    end
  end

  def terminate(_reason, socket) do
    Chat.LoginUser.logout(socket.channel_pid)
  end
end
