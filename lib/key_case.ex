defmodule KeyCase do
  def snake_case(map) when is_map(map) do
    snake_case_key(map)
  end

  defp snake_case_key(map) when is_map(map) do
    for {key, value} <- map, into: %{} do
      case is_map(value) do
        true -> {snake_case_key(key), snake_case_key(value)}
        false -> {snake_case_key(key), value}
      end
    end
  end

  defp snake_case_key(atom) when is_atom(atom) do
    atom |> to_string() |> snake_case_key()
  end

  defp snake_case_key(string) when is_binary(string) do
    Macro.underscore(string)
  end

  defp snake_case_key(key), do: key
end
