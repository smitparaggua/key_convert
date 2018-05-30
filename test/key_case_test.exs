defmodule KeyCaseTest do
  use ExUnit.Case, async: true
  doctest KeyCase

  describe ".snake_case" do
    test "converts the keys to snake case" do
      input = %{totalAmount: 500}
      assert KeyCase.snake_case(input) == %{"total_amount" => 500}
    end

    test "converts the keys of nested map" do
      input = %{contactInfo: %{emailAddress: "email@example.com"}}
      assert KeyCase.snake_case(input) == %{
        "contact_info" => %{"email_address" => "email@example.com"}
      }
    end
  end
end
