defmodule Chat.LoginUser do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def login(pid, name) do
    Agent.get_and_update(__MODULE__, fn enum ->
      case Enum.any?(enum, fn {_pid, n} -> n === name end) do
        true -> {:error, enum}
        false -> {:ok, [{pid, name}|enum]}
      end
    end)
  end

  def logout(pid) do
    Agent.cast(__MODULE__, fn enum ->
      Enum.reject(enum, fn {p, _name} -> p === pid end)
    end)
  end

  def user(pid) do
    Agent.get(__MODULE__, fn enum ->
      Enum.find(enum, fn {p, n} -> p === pid end) |> elem(1)
    end)
  end

  def users do
    Agent.get(__MODULE__, fn enum ->
      Enum.map(enum, fn {_, name} -> name end)
    end)
  end
end
