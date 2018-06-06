defmodule KeyConvertTest do
  use ExUnit.Case, async: true
  doctest KeyConvert

  describe ".snake_case" do
    test "converts the keys to snake case" do
      input = %{totalAmount: 500}
      assert KeyConvert.snake_case(input) == %{"total_amount" => 500}
    end

    test "converts the keys of nested map" do
      input = %{contactInfo: %{emailAddress: "email@example.com"}}
      assert KeyConvert.snake_case(input) == %{
        "contact_info" => %{"email_address" => "email@example.com"}
      }
    end

    test "does not replace dots in the key name" do
      input = %{"email@example.com" => :email}
      assert KeyConvert.snake_case(input) == input
    end
  end

  describe ".camelize" do
    test "converts the Map keys to camel case" do
      assert KeyConvert.camelize(%{total_amount: 500}) == %{"totalAmount" => 500}
    end

    test "converts keys of nested map" do
      input = %{
        contact_details: %{
          phone_number: "555-55-55",
          email_address: "email@example.com"
        }
      }

      assert KeyConvert.camelize(input) == %{
        "contactDetails" => %{
          "phoneNumber" => "555-55-55",
          "emailAddress" => "email@example.com"
        }
      }
    end
  end

  describe ".rename" do
    test "changes the key based on a translation map" do
      input = %{total_amount: 500}
      rename_map = %{total_amount: :value}
      expected = %{value: 500}
      assert KeyConvert.rename(input, rename_map) == expected
    end

    test "ignores any extra keys" do
      input = %{total_amount: 500, currency: "PHP"}
      rename_map = %{total_amount: :value}
      expected = %{value: 500, currency: "PHP"}
      assert KeyConvert.rename(input, rename_map) == expected
    end

    test "supports nested maps" do
      input = %{
        contact_details: %{
          phone_number: "555-55-55",
          email_address: "email@example.com"
        }
      }

      rename_map = %{
        contact_details: :contact,
        phone_number: :phone,
        email_address: :email
      }

      expected = %{
        contact: %{
          phone: "555-55-55",
          email: "email@example.com"
        }
      }

      assert KeyConvert.rename(input, rename_map) == expected
    end
  end

  describe ".convert" do
    test "converts the keys based on the function provided" do
      converter = fn key -> key <> ".changed" end
      input = %{"total_amount" => 500}
      assert KeyConvert.convert(input, converter) == %{
        "total_amount.changed" => 500
      }
    end

    test "supports nested maps" do
      converter = fn key -> key <> ".changed" end
      input = %{
        "contact_details" => %{
          "phone_number" => "555-55-55",
          "email_address" => "email@example.com"
        }
      }

      assert KeyConvert.convert(input, converter) == %{
        "contact_details.changed" => %{
          "phone_number.changed" => "555-55-55",
          "email_address.changed" => "email@example.com"
        }
      }
    end
  end
end
