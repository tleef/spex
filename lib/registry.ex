defmodule Spex.Registry do
  use Agent

  def start_link(args) do
    initial_state = Keyword.get(args, :initial_state, %{})
    name = Keyword.get(args, :name, __MODULE__)
    Agent.start_link(fn -> initial_state end, name: name)
  end

  def register(k, nil) when is_atom(k) do
    Agent.update(__MODULE__, &Map.delete(&1, k))
  end

  def register(k, spec) when is_atom(k) do
    Agent.update(__MODULE__, &Map.put(&1, k, spec))
  end

  def resolve(k) when is_atom(k) do
    Agent.get(__MODULE__, &Map.get(&1, k))
  end

  def resolve(k) do
    k
  end

  def resolve!(k) do
    resolve(k)
    |> case do
      nil -> raise ArgumentError, message: "Unable to resolve spec: #{k}"
      spec -> spec
    end
  end
end
