defmodule Day02 do
  @doc """
  Advent of Code 2023 Day 2 Part 1

  ## Examples

      iex> Day02.part1("files/day02_example_part1.txt")
      8
  """
  def part1(filename) do
    File.stream!(filename)
    |> Enum.filter(&valid_game/1)
    |> Enum.map(&game_id/1)
    |> Enum.sum
  end

  @doc """
  Advent of Code 2023 Day 2 Part 2

  ## Examples

      iex> Day02.part2("files/day02_example_part1.txt")
      2286
  """
  def part2(filename) do
    File.stream!(filename)
    |> Enum.map(&game_power/1)
    |> Enum.sum
  end

  defp game_power(line) do
    String.split(line, ":")
    |> Enum.at(-1)
    |> String.split(";")
    |> Enum.reduce(%{red: 1, green: 1, blue: 1}, &min_required_cubes/2)
    |> Map.values
    |> Enum.reduce(fn (i, acc) -> acc * i end)
  end

  defp min_required_cubes(input, acc) do
    Regex.scan(~r/(\d+) (red|green|blue)/, input)
    |> Enum.reduce(acc, &combine_result/2)
  end

  defp combine_result(set, acc) do
    count = String.to_integer(Enum.at(set, 1))
    colour = String.to_atom(Enum.at(set, 2))
    Map.merge(acc, %{colour => max(count, acc[colour])})
  end

  defp valid_game(line) do
    String.split(line, ":")
    |> Enum.at(-1)
    |> String.split(";")
    |> Enum.all?(&valid_set/1)
  end

  defp valid_set(input) do
    Regex.scan(~r/(\d+) (red|green|blue)/, input)
    |> Enum.all?(&valid_draw/1)
  end

  defp valid_draw(input) do
    case Enum.at(input, 2) do
      "red" -> Enum.at(input, 1) |> String.to_integer <= 12
      "green" -> Enum.at(input, 1) |> String.to_integer <= 13
      "blue" -> Enum.at(input, 1) |> String.to_integer <= 14
      _ -> false
    end
  end

  defp game_id(line) do
    Regex.run(~r/Game (\d+)/, line) |> Enum.at(-1) |> String.to_integer
  end
end
