defmodule KeyCaseTest do
  use ExUnit.Case
  doctest KeyCase

  test "greets the world" do
    assert KeyCase.hello() == :world
  end
end
