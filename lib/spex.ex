defmodule Spex do
  alias Spex.Spec

  @doc """
  Given an atom k, and a spec object, makes an entry in the registry
  mapping k to the spec. Use nil to remove an entry in the registry for k.
  """
  def register(k, spec) do 
    Spex.Registry.register(k, spec)
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
end
