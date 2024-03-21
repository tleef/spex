defmodule Specx do
  alias Specx.Spec

  defmacro __using__(_) do
    quote do
      import Specx, only: [
        spec: 2,
        map: 0,
        map: 1,
        map: 2,
        list: 0,
        list: 1,
        list: 2,
        tuple: 0,
        tuple: 1,
        tuple: 2
      ]
    end
  end

  defmacro spec(name, spec) do
    quote do
      Specx.register(unquote(name), unquote(spec))
    end
  end

  @doc """
  Given an atom k, and a spec object, makes an entry in the registry
  mapping k to the spec. Use nil to remove an entry in the registry for k.
  """
  def register(k, spec) when is_atom(k) do 
    Specx.Registry.register(k, spec)
  end

  @doc """
  Given a spec and a value, 
  returns :invalid if value does not match spec, 
  else (possibly destructured value.
  """
  def conform(spec, x) do
    Spec.conform(spec, x)
  end

  @doc """
  tests the validity of a conform return value
  """
  def invalid?(ret) do
    ret == :invalid
  end

  @doc """
  Helper function that returns true when x is valid for spec.
  """
  def valid?(spec, x) do 
    Spec.conform(spec, x)
    |> invalid?()
    |> Kernel.not()
  end

  def map(key_specs \\ [], opts \\ []) do
    {:map, key_specs, opts}
  end

  def list(items_spec \\ &any?/1, opts \\ []) do
    {:list, items_spec, opts}
  end

  def tuple(elem_specs \\ [], opts \\ []) do
    {:tuple, elem_specs, opts}
  end

  def any?(_), do: true
end
