defmodule Chat.Message do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add(user, body) do
    Agent.cast(__MODULE__, fn enum -> [{user, body}|enum] end)
  end

  def get(n \\ 100) do
    case n do
      :all -> Agent.get(__MODULE__, fn enum -> enum end)
      _    -> Agent.get(__MODULE__, fn enum -> enum end) |> Enum.take(n)
    end
  end
end
