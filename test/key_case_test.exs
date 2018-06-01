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

    test "does not replace dots in the key name" do
      input = %{"email@example.com" => :email}
      assert KeyCase.snake_case(input) == input
    end
  end

  describe ".camelize" do
    test "converts the Map keys to camel case" do
      assert KeyCase.camelize(%{total_amount: 500}) == %{"totalAmount" => 500}
    end

    test "converts keys of nested map" do
      input = %{
        contact_details: %{
          phone_number: "555-55-55",
          email_address: "email@example.com"
        }
      }

      assert KeyCase.camelize(input) == %{
        "contactDetails" => %{
          "phoneNumber" => "555-55-55",
          "emailAddress" => "email@example.com"
        }
      }
    end
  end
end
