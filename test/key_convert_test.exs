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

    test "retains keys which are neither atoms nor strings" do
      assert KeyConvert.snake_case(%{1 => 1}) == %{1 => 1}
    end

    test "supports shallow mode" do
      input = %{contactInfo: %{emailAddress: "email@example.com"}}
      expected = %{"contact_info" => %{emailAddress: "email@example.com"}}
      assert KeyConvert.snake_case(input, mode: :shallow) == expected
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

      expected = %{
        "contactDetails" => %{
          "phoneNumber" => "555-55-55",
          "emailAddress" => "email@example.com"
        }
      }

      assert KeyConvert.camelize(input) == expected
    end

    test "retains keys which are neither atoms nor strings" do
      assert KeyConvert.camelize(%{1 => 1}) == %{1 => 1}
    end

    test "supports shallow mode" do
      input = %{contact_info: %{email_address: "email@example.com"}}
      expected = %{"contactInfo" => %{email_address: "email@example.com"}}
      assert KeyConvert.camelize(input, mode: :shallow) == expected
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

    test "supports shallow mode" do
      input = %{contact_info: %{email_address: "email@example.com"}}

      rename_map = %{
        contact_info: :contact,
        email_address: :email
      }

      expected = %{contact: %{email_address: "email@example.com"}}
      assert KeyConvert.rename(input, rename_map, mode: :shallow) == expected
    end
  end

  describe ".stringify" do
    test "converts atom keys to string" do
      input = %{contact_info: %{email_address: "email@example.com"}}
      expected = %{"contact_info" => %{"email_address" => "email@example.com"}}
      assert KeyConvert.stringify(input) == expected
    end

    test "supports options" do
      input = %{contact_info: %{email_address: "email@example.com"}}
      expected = %{"contact_info" => %{email_address: "email@example.com"}}
      assert KeyConvert.stringify(input, mode: :shallow) == expected
    end

    test "ignores non-atom keys" do
      input = %{false => "test", 1 => "test-2", :atom => "test-3"}
      expected = %{false => "test", 1 => "test-2", "atom" => "test-3"}
      assert KeyConvert.stringify(input) == expected
    end
  end

  describe ".atomize" do
    test "converts string keys to atom" do
      assert KeyConvert.atomize(%{"amount" => 100}) == %{amount: 100}
    end

    test "supports options" do
      input = %{"contact_info" => %{"email_address" => "email@example.com"}}
      expected = %{contact_info: %{"email_address" => "email@example.com"}}
      assert KeyConvert.atomize(input, mode: :shallow) == expected
    end

    test "ignores non-string keys" do
      assert KeyConvert.atomize(%{100 => "amount"}) == %{100 => "amount"}
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

    test "converts only first level on shallow mode" do
      converter = fn key -> key <> ".changed" end
      input = %{"contact_details" => %{"phone_number" => "555-55-55"}}
      expected = %{"contact_details.changed" => %{"phone_number" => "555-55-55"}}
      assert KeyConvert.convert(input, converter, mode: :shallow) == expected
    end
  end
end
