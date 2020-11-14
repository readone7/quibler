defmodule QuiblerTest do
  use ExUnit.Case
  doctest Quibler

  test "greets the world" do
    assert Quibler.hello() == :world
  end
end
