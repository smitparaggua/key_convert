defmodule KeyCase do
  def snake_case(map) when is_map(map) do
    convert(map, &do_snake_case/1)
  end

  defp do_snake_case(atom) when is_atom(atom) do
    atom |> to_string() |> do_snake_case()
  end

  defp do_snake_case(string) when is_binary(string) do
    string
    |> String.split(".")
    |> Enum.map(&Macro.underscore/1)
    |> Enum.join(".")
  end

  defp do_snake_case(key), do: key

  def camelize(map) when is_map(map) do
    convert(map, &do_camelize/1)
  end

  defp do_camelize(atom) when is_atom(atom) do
    atom |> to_string() |> do_camelize()
  end

  defp do_camelize(string) when is_binary(string) do
    tail = string |> Macro.camelize() |> String.slice(1..-1)
    String.first(string) <> tail
  end

  defp do_camelize(key), do: key

  def convert(map, converter) when is_map(map) and is_function(converter, 1) do
    for {key, value} <- map, into: %{} do
      new_key = converter.(key)
      case is_map(value) do
        true -> {new_key, convert(value, converter)}
        false -> {new_key, value}
      end
    end
  end
end
