defmodule SpecxTest do
  use ExUnit.Case
  doctest Specx

  test "greets the world" do
    assert Specx.hello() == :world
  end
end
