defmodule Day09 do
  @doc """
  Advent of Code 2023 Day 9 Part 1

  ## Examples

      iex> Day09.part1("files/day09_example_part1.txt")
      114
  """
  def part1(filename) do
    File.stream!(filename)
    |> Enum.map(fn line -> String.split(line) |> Enum.map(&String.to_integer/1) |> find_next end)
    |> Enum.sum
  end

  @doc """
  Advent of Code 2023 Day 9 Part 2

  ## Examples

      iex> Day09.part2("files/day09_example_part1.txt")
      2
  """
  def part2(filename) do
    File.stream!(filename)
    |> Enum.map(fn line -> String.split(line) |> Enum.map(&String.to_integer/1) |> find_prev end)
    |> Enum.sum
  end

  defp find_next(input) do
    next_input = Enum.chunk_every(input, 2, 1, :discard) |> Enum.map(fn [a, b] -> b - a end)

    if Enum.all?(next_input, fn x -> x == 0 end) do
      input |> List.last
    else
      find_next(next_input) + (input |> List.last)
    end
  end

  defp find_prev(input) do
    next_input = Enum.chunk_every(input, 2, 1, :discard) |> Enum.map(fn [a, b] -> b - a end)

    if Enum.all?(next_input, fn x -> x == 0 end) do
      input |> List.first
    else
      (input |> List.first) - find_prev(next_input)
    end
  end
end
