defmodule Day01 do
  @doc """
  Advent of Code 2023 Day 1 Part 1

  ## Examples

      iex> Day01.part1("files/day01_example_part1.txt")
      142
  """
  def part1(filename) do
    File.stream!(filename)
      |> Enum.map(&find_digits/1)
      |> Enum.sum
  end

  @doc """
  Advent of Code 2023 Day 1 Part 2

  ## Examples

      iex> Day01.part2("files/day01_example_part2.txt")
      281
  """
  def part2(filename) do
    File.stream!(filename)
    |> Enum.map(&find_digits_with_words/1)
    |> Enum.sum
  end

  defp find_digits_with_words(line) do
    Regex.scan(~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/, line)
    |> Enum.map(fn (a) -> Enum.at(a, -1) end)
    |> List.flatten
    |> first_and_last
    |> Enum.map(&word_to_digit/1)
    |> Enum.join
    |> String.to_integer
  end

  defp word_to_digit(input) do
    case input do
      "one" -> "1"
      "two" -> "2"
      "three" -> "3"
      "four" -> "4"
      "five" -> "5"
      "six" -> "6"
      "seven" -> "7"
      "eight" -> "8"
      "nine" -> "9"
      _ -> input
    end
  end

  defp find_digits(line) do
    Regex.scan(~r/\d/, line)
    |> List.flatten
    |> first_and_last
    |> Enum.join
    |> String.to_integer
  end

  defp first_and_last(digits) do
    [first | _rest] = digits
    result = [first, Enum.at(digits, -1)]
    result
  end
end
