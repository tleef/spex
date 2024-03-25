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
  def conform({:map, key_specs, _opts}, x) do
    if not is_map(x), do: throw(:invalid)
  catch
    :invalid -> :invalid
  end

  def conform({:list, items_spec, _opts}, x) do
    if not is_list(x), do: throw(:invalid)

    Enum.map(x, fn item ->
      Specx.conform(items_spec, item)
      |> case do
        :invalid -> throw(:invalid)
        result -> result
      end
    end)
  catch
    :invalid -> :invalid
  end

  def conform({:tuple, elem_specs, _opts}, x) do
    if not is_tuple(x), do: throw(:invalid)
  catch
    :invalid -> :invalid
  end
end
