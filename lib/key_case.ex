defmodule KeyCase do
  def snake_case(map) when is_map(map) do
    do_snake_case(map)
  end

  defp do_snake_case(map) when is_map(map) do
    for {key, value} <- map, into: %{} do
      case is_map(value) do
        true -> {do_snake_case(key), do_snake_case(value)}
        false -> {do_snake_case(key), value}
      end
    end
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

  def camelize(map) when is_map(map), do: do_camelize(map)

  defp do_camelize(map) when is_map(map) do
    for {key, value} <- map, into: %{} do
      {do_camelize(key), do_camelize(value)}
    end
  end

  defp do_camelize(atom) when is_atom(atom) do
    atom |> to_string() |> do_camelize()
  end

  defp do_camelize(string) when is_binary(string) do
    String.first(string) <> (string |> Macro.camelize() |> String.slice(1..-1))
  end

  defp do_camelize(key), do: key
end
