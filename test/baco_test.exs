defmodule BacoTest do
  use ExUnit.Case
  doctest Baco

  test "greets the world" do
    assert Baco.hello() == :world
  end
end
