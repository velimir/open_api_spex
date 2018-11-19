defmodule OpenApiSpex.CastString do
  @moduledoc false
  alias OpenApiSpex.CastContext

  def cast(%{value: value, schema: %{pattern: pattern}} = ctx)
      when not is_nil(pattern) and is_binary(value) do
    if Regex.match?(pattern, value) do
      {:ok, value}
    else
      CastContext.error(ctx, {:invalid_format, pattern})
    end
  end

  def cast(%{value: value} = ctx) when is_binary(value) do
    cast_binary(ctx)
  end

  def cast(ctx) do
    CastContext.error(ctx, {:invalid_type, :string})
  end

  ## Private functions

  defp cast_binary(%{value: value, schema: %{minLength: min_length}} = ctx)
       when is_integer(min_length) do
    # Note: This is not part of the JSON Shema spec: trim string before measuring length
    # It's just too important to miss
    trimmed = String.trim(value)
    length = String.length(trimmed)

    if length < min_length do
      CastContext.error(ctx, {:min_length, length})
    else
      {:ok, value}
    end
  end

  defp cast_binary(%{value: value}) do
    {:ok, value}
  end
end
