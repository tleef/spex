defprotocol Specx.Spec do
  def conform(spec, x)
  #  def unform(spec, y)
  #  def explain(spec, path, via, in, x)
  #  def gen(spec, overrides, path, rmap)
  #  def with_gen(spec, gfn)
  #  def describe(spec)
end

defimpl Specx.Spec, for: Function do
  def conform(spec, x) do
    spec.(x)
    |> case do
      true -> x
      false -> :invalid
    end
  end
end

defimpl Specx.Spec, for: Atom do
  def conform(spec, x) do
    Specx.Registry.resolve!(spec)
    |> Specx.conform(x)
  end
end

defimpl Specx.Spec, for: Tuple do
  def conform({:map, key_spec, opts}, x) do
    x
  end

  def conform({:list, items_spec, opts}, x) do
    x
  end

  def conform({:tuple, elem_specs, opts}, x) do
    x
  end
end
