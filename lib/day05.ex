defmodule Day05 do
  @doc """
  Advent of Code 2023 Day 5 Part 1

  Examples:

    iex> Day05.part1("files/day05_example_part1.txt")
    35
  """
  def part1(filename) do
    mappings = read_input(filename)

    Enum.at(mappings["seeds"], 0)
    |> Enum.map(fn seed -> location(seed, mappings) end)
    |> Enum.min
  end

  @doc """
  Advent of Code 2023 Day 5 Part 1

  Examples:

    iex> Day05.part2("files/day05_example_part1.txt")
    46
  """
  def part2(filename) do
    mappings = read_input(filename)
    seeds = Enum.at(mappings["seeds"], 0)

    Enum.find(Stream.iterate(0, &(&1 + 1)), fn location ->
      valid_seed?(find_seed(location, mappings), seeds)
    end)
  end

  defp read_input(filename) do
    {:ok, contents} = File.read(filename)

    contents
    |> String.split("\n\n")
    |> Enum.into(%{}, fn x ->
      [k, v] = String.split(x, ":") |> Enum.map(&String.trim/1)
      {k, String.split(v, "\n") |> Enum.map(&number_list/1)}
    end)
  end

  defp number_list(str) do
    String.split(str, " ") |> Enum.map(&String.to_integer/1)
  end

  defp valid_seed?(seed, seeds) do
    seeds
    |> Enum.chunk_every(2)
    |> Enum.find(fn [start, count] -> start <= seed && seed < start + count end)
  end

  defp find_seed(location, mappings) do
    items = [
      "humidity-to-location map",
      "temperature-to-humidity map",
      "light-to-temperature map",
      "water-to-light map",
      "fertilizer-to-water map",
      "soil-to-fertilizer map",
      "seed-to-soil map"
    ]

    items
    |> Enum.reduce(location, fn map_name, result ->
      [dst, src, _] = mappings[map_name]
      |> Enum.find([0, 0, 0], fn [dst, _, count] ->
        dst <= result && result < dst + count
      end)

      result - (dst - src)
    end)
  end

  defp location(seed, mappings) do
    items = [
      "seed-to-soil map",
      "soil-to-fertilizer map",
      "fertilizer-to-water map",
      "water-to-light map",
      "light-to-temperature map",
      "temperature-to-humidity map",
      "humidity-to-location map"
    ]

    items
    |> Enum.reduce(seed, fn map_name, result ->
      [dst, src, _] = mappings[map_name]
      |> Enum.find([0, 0, 0], fn [_, src, count] ->
        src <= result && result < src + count
      end)

      result + (dst - src)
    end)
  end
end
