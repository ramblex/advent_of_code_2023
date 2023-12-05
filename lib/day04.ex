defmodule Day04 do
  @doc """
  Advent of Code 2023 Day 4 Part 1

  ## Examples

    iex> Day04.part1("files/day04_example_part1.txt")
    13
  """
  def part1(filename) do
    File.stream!(filename)
    |> Enum.map(&count_points/1)
    |> Enum.sum
  end

  @doc """
  Advent of Code 2023 Day 4 Part 2

  ## Examples

    iex> Day04.part2("files/day04_example_part1.txt")
    30
  """
  def part2(filename) do
    partial_results = File.stream!(filename)
    |> Enum.into(%{}, &count_matches/1)

    Enum.reduce(map_size(partial_results)..1, %{}, fn card, instances ->
      matches = partial_results[card]

      if matches == 0 do
        Map.put(instances, card, 1)
      else
        sub_matches = Enum.map(card + 1..card + matches, fn x -> instances[x] end)
        |> Enum.reject(&is_nil/1)
        |> Enum.sum

        Map.put(instances, card, sub_matches + 1)
      end
    end)
    |> Map.values
    |> Enum.sum
  end

  defp count_matches(line) do
    [card_name, scores] = String.split(line, ":")
    card_number = Enum.at(Regex.run(~r/\d+/, card_name), 0)
    [winning, mine] = String.split(scores, "|")
    common = MapSet.intersection(uniq_numbers(winning), uniq_numbers(mine))
    {String.to_integer(card_number), MapSet.size(common)}
  end

  defp count_points(line) do
    [_card, scores] = String.split(line, ":")
    [winning, mine] = String.split(scores, "|")
    common = MapSet.intersection(uniq_numbers(winning), uniq_numbers(mine))

    if MapSet.size(common) == 0 do
      0
    else
      2 ** (MapSet.size(common) - 1)
    end
  end

  defp uniq_numbers(str) do
    result = Regex.scan(~r/\d+/, str)
    |> Enum.map(fn x -> String.to_integer(Enum.at(x, 0)) end)

    MapSet.new(result)
  end
end
