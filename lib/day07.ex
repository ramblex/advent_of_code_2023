defmodule Day07 do
  @doc """
  Advent of Code 2023 Day 7 part 1

  ## Examples

    iex> Day07.part1("files/day07_input_example.txt")
    6440
  """
  def part1(filename) do
    File.stream!(filename)
    |> Enum.map(fn ln ->
      [cardstr, bid] = String.split(ln)
      cards = String.graphemes(cardstr)
      [card_type(cards), Enum.map(cards, &card_points_pt1/1), String.to_integer(bid)]
    end)
    |> Enum.sort
    |> Enum.with_index
    |> Enum.reduce(0, fn {r, idx}, acc -> acc + (List.last(r) * (idx + 1)) end)
    |> IO.inspect(charlists: :as_list)
  end

  @doc """
  Advent of Code 2023 Day 7 part 2

  ## Examples

    iex> Day07.part2("files/day07_input_example.txt")
    5905
  """
  def part2(filename) do
    File.stream!(filename)
    |> Enum.map(fn ln ->
      [cardstr, bid] = String.split(ln)
      cards = String.graphemes(cardstr)
      [card_type_part2(cards), Enum.map(cards, &card_points_pt2/1), cardstr, String.to_integer(bid)]
    end)
    |> Enum.sort
    |> IO.inspect(charlists: :as_lists)
    |> Enum.with_index
    |> Enum.reduce(0, fn {r, idx}, acc -> acc + (List.last(r) * (idx + 1)) end)
  end

  defp card_points_pt1(card) do
    Enum.find_index(["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"], fn x -> x == card end)
  end

  defp card_points_pt2(card) do
    Enum.find_index(["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"], fn x -> x == card end)
  end

  defp card_type_part2(cards) do
    grouped_cards = Enum.reduce(cards, %{}, fn x, acc ->
      Map.put(acc, x, (acc[x] || 0) + 1)
    end)

    jokers = grouped_cards["J"] || 0
    counts = grouped_cards |> Map.delete("J") |> Map.values |> Enum.sort

    counts = case List.last(counts) do
      nil -> [5]
      last_element -> List.replace_at(counts, -1, last_element + jokers)
    end

    counts_value(counts)
  end

  defp card_type(cards) do
    grouped_cards = Enum.reduce(cards, %{}, fn x, acc ->
      Map.put(acc, x, (acc[x] || 0) + 1)
    end)

    counts = Map.values(grouped_cards) |> Enum.sort
    counts_value(counts)
  end

  defp counts_value(counts) do
    cond do
      counts == [5] -> 7 # Five of a kind
      counts == [1, 4] -> 6 # Four of a kind
      counts == [2, 3] -> 5 # Full house
      counts == [1, 1, 3] -> 4 # Three of a kind
      counts == [1, 2, 2] -> 3 # Two pair
      Enum.member?(counts, 2) -> 2 # Pair
      true -> 1
    end
  end
end
