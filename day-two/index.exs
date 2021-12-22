defmodule AdventDayTwo do
  def solution do
    nav_data = get_nav_data("day-two/nav_commands.txt")
    starting_position = {0, 0, 0} # x,y, aim; horizontal, depth, aim

    steer_the_sub(nav_data, starting_position)
  end

  defp get_nav_data(filename) do
    {:ok, cwd} = File.cwd()

    case File.read("#{cwd}/#{filename}") do
      {:ok, body} -> parse_data(body)
      {:error, reason} -> IO.puts(reason)
    end
  end

  defp parse_data(data) do
    # parse the data into a "keyword list"
    Enum.map(
      String.split(data, "\r\n", trim: true),
      fn line ->
        [dir, num] = String.split(line)
        {String.to_atom(dir), String.to_integer(num)}
      end
    )
  end

  defp steer_the_sub([], {horizontal, depth, _aim}) do
    IO.puts "Horizontal: #{horizontal}, Depth: #{depth}\nComputed: #{horizontal * depth}"
  end

  defp steer_the_sub([head | tail], {horizontal, depth, aim}) do
    # this function will do the nav math step by step
    new_position = case head do
      {:forward, x} -> {horizontal + x, depth + (aim * x), aim}
      {:down, x} -> {horizontal, depth, aim + x}
      {:up, x} -> {horizontal, depth, aim - x}
    end

    steer_the_sub(tail, new_position)
  end
end

AdventDayTwo.solution()
