defmodule CrcTest do
  use ExUnit.Case
  doctest Crc

  test "greets the world" do
    assert Crc.hello() == :world
  end
end
