defmodule Day06 do
  @doc """
  Advent of Code 2023 Day 6 Part 1

  Examples:

    iex> Day06.part1("files/day06_example_part1.txt")
    288
  """
  def part1(filename) do
    read_input(filename, &number_list/1)
    |> Enum.map(fn {t, d} ->
      Enum.filter(0..t, fn pause ->
        pause * (t - pause) > d
      end)
      |> Enum.count
    end)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  @doc """
  Advent of Code 2023 Day 6 Part 2

  Examples:

    iex> Day06.part2("files/day06_example_part1.txt")
    71503
  """
  def part2(filename) do
    read_input(filename, &number_smush/1)
    |> Enum.map(fn {t, d} ->
      Enum.filter(0..t, fn pause ->
        pause * (t - pause) > d
      end)
      |> Enum.count
    end)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  defp read_input(filename, list_fun) do
    {:ok, contents} = File.read(filename)

    contents
    |> String.split("\n")
    |> Enum.reject(fn line -> line == "" end)
    |> Enum.map(fn line ->
      [_k, v] = String.split(line, ":")
      list_fun.(v)
    end)
    |> Enum.zip
  end

  defp number_list(str) do
    Regex.scan(~r/\d+/, str) |> List.flatten |> Enum.map(&String.to_integer/1)
  end

  defp number_smush(str) do
    [Regex.scan(~r/\d+/, str) |> List.flatten |> Enum.join |> String.to_integer]
  end
end
