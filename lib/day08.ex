defmodule Day08 do
  @doc """
  Advent of Code 2023 Day 8 Part 1

  ## Examples

    iex> Day08.part1("files/day08_example_part1.txt")
    2

    iex> Day08.part1("files/day08_example_part1_example2.txt")
    6
  """
  def part1(filename) do
    {instructions, network} = read_input(filename)

    Stream.cycle(instructions)
    |> Enum.reduce_while({0, "AAA"}, fn inst, acc ->
      {count, current_node} = acc

      case current_node do
        "ZZZ" -> {:halt, count}
        _ -> {:cont, {count + 1, next_node(inst, current_node, network)}}
      end
    end)
  end

  @doc """
  Advent of Code 2023 Day 8 Part 2

  ## Examples

    iex> Day08.part2("files/day08_example_part2.txt")
    6
  """
  def part2(filename) do
    {instructions, network} = read_input(filename)

    network
    |> Map.keys
    |> Enum.filter(fn node -> String.ends_with?(node, "A") end)
    |> Enum.map(fn node -> count_node(node, instructions, network) end)
    |> Enum.reduce(1, fn c, acc -> trunc(lcm(c, acc)) end)
  end

  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: (a * b) / gcd(a, b)

  defp count_node(start_node, instructions, network) do
    Stream.cycle(instructions)
    |> Enum.reduce_while({0, start_node}, fn inst, acc ->
      {count, current_node} = acc

      cond do
        String.ends_with?(current_node, "Z") ->
          {:halt, count}
        true ->
          {:cont, {count + 1, next_node(inst, current_node, network)}}
      end
    end)
  end

  defp next_node(inst, current_node, network) do
    next_node_idx = case inst do
      "L" -> 0
      "R" -> 1
    end

    Enum.at(network[current_node], next_node_idx)
  end

  defp read_input(filename) do
    {:ok, contents} = File.read(filename)

    [instructions, networkstr] = String.split(contents, "\n\n")

    network = String.split(networkstr, "\n")
    |> Enum.reject(fn line -> line == "" end)
    |> Enum.into(%{}, fn line ->
      [current | directions] = Regex.scan(~r/[A-Z0-9]{3}/, line) |> List.flatten
      {current, directions}
    end)

    instructions = String.graphemes(instructions)

    {instructions, network}
  end
end
