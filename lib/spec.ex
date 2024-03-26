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

    Map.merge(
      x,
      Enum.reduce(key_specs, %{}, fn spec, result ->
        Specx.conform(spec, Map.get(x, resolve_key(spec)))
        |> case do
          :invalid -> throw(:invalid)
          val -> Map.put(result, resolve_key(spec), val)
        end
      end)
    )
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
    if elem_specs != [] and length(elem_specs) != tuple_size(x), do: throw(:invalid)

    Enum.with_index(elem_specs)
    |> Enum.reduce({}, fn {spec, index}, result ->
      Specx.conform(spec, elem(x, index))
      |> case do
        :invalid -> throw(:invalid)
        el -> Tuple.insert_at(result, index, el)
      end
    end)
  catch
    :invalid -> :invalid
  end

  defp resolve_key(spec) when is_atom(spec) do
    Atom.to_string(spec)
    |> String.split("/")
    |> List.last()
    |> String.to_existing_atom()
  end
end
