defmodule Specx.Registry do
  use GenServer

  @table __MODULE__

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def init(opts) do
    :ets.new(@table, [:named_table, :public, :set])

    Keyword.get(opts, :initial_specs, [])
    |> register_batch()

    {:ok, nil}
  end

  def register(k, nil) when is_atom(k) do
    :ets.delete(@table, k)
  end

  def register(k, spec) when is_atom(k) do
    :ets.insert(@table, {k, spec})
  end

  def resolve(k) when is_atom(k) do
    :ets.lookup(@table, k)
    |> case do
      [{^k, spec}] -> spec
      [] -> nil
    end
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

  defp register_batch([]) do
    false
  end

  defp register_batch(spec_defs) do
    :ets.insert(@table, spec_defs)
  end
end
