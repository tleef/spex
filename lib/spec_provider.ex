defmodule Specx.SpecProvider do
  @callback __initial_specs__() :: [{atom(), any()}]

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)
      @before_compile unquote(__MODULE__)

      Module.register_attribute(__MODULE__, :initial_specs, accumulate: true)

      import unquote(__MODULE__), only: [spec: 2]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def __initial_specs__() do
        @initial_specs
      end
    end
  end

  defmacro spec(k, spec) do
    quote do
      Module.put_attribute(__MODULE__, :initial_specs, {unquote(k), unquote(spec)})
    end
  end

  def initial_specs() do
    Specx.Reflection.impls(Specx.SpecProvider)
    |> Enum.reduce([], fn mod, specs -> specs ++ mod.__initial_specs__() end)
  end
end
