defmodule Day03 do
  @doc """
  Advent of Code 2023 Day 3 Part 1

  ## Examples

      iex> Day03.part1("files/day03_example_part1.txt")
      4361
  """
  def part1(filename) do
    File.stream!(filename)
    |> Enum.chunk_every(2, 1)
    |> Enum.reduce({[], ""}, &find_part_numbers/2)
    |> fn {result, _} -> Enum.sum(result) end.()
  end

  defp find_part_numbers(lines, acc) do
    {result, previous_line} = acc
    [current_line | next_line] = lines

    matching = Regex.scan(~r/\d+/, current_line, return: :index)
    |> Enum.filter(fn [{start, count}] ->
        offset = count + min(0, start - 1)

        top = String.slice(previous_line, max(0, start - 1), offset + 2)
        right = String.slice(current_line, start + count, 1)
        bottom = String.slice(Enum.at(next_line, 0) || "", max(0, start - 1), offset + 2)
        left = String.slice(current_line, max(0, start - 1), 1 + min(0, start - 1))
        Enum.any?([top, right, bottom, left], &contains_symbol?/1)
      end)
    |> List.flatten
    |> Enum.map(fn {start, count} -> String.to_integer(String.slice(current_line, start, count)) end)

    {result ++ matching, current_line}
  end

  defp contains_symbol?(str) do
    Enum.any?(String.graphemes(str), fn c ->
      !Enum.member?([".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "\n"], c)
    end)
  end
end
