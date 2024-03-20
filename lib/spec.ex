defprotocol Spex.Spec do
  def conform(spec, x)
  #  def unform(spec, y)
  #  def explain(spec, path, via, in, x)
  #  def gen(spec, overrides, path, rmap)
  #  def with_gen(spec, gfn)
  #  def describe(spec)
end

defimpl Spex.Spec, for: Function do
  def conform(spec, x) do
    spec.(x)
    |> case do
      true -> x
      false -> :invalid
    end
  end
end

defimpl Spex.Spec, for: Atom do
  def conform(spec, x) do
    Spex.Registry.resolve!(spec)
    |> Spex.conform(x)
  end
end
