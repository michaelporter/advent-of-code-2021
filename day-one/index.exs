defmodule AdventDayOne do
  def solution do
    depth_readings = collect_data("day-one/depth_measurements.txt")

    # split the list into the tail (tl) and head (hd)
    # to kick off the recursion
    count_increases(tl(depth_readings), hd(depth_readings))

    # measuring groups of three
    # slice the first 3 and send the tail
    [a, b, c | _rem] = depth_readings
    count_for_sliding_window(tl(depth_readings), (a + b + c))
  end

  defp collect_data(file_name) do
    {:ok, cwd} = File.cwd()

    case File.read("#{cwd}/#{file_name}") do
      {:ok, body} -> convert_data_to_ints(body)
      {:error, reason} -> IO.puts(reason)
    end
  end

  defp convert_data_to_ints(data) do
    Enum.map(String.split(data, "\r\n", trim: true), fn x -> String.to_integer(x) end )
  end

  # fn signature with no body is required for setting a default value
  #   for a fn tha has multiple clauses
  defp count_increases(data, previous_value, count \\ 0)

  # version of the function to run when the list is not empty
  #   note the "matching" done for the first argument
  defp count_increases([head | tail], previous_value, count) when is_integer(head) do
    new_count = if head > previous_value do
      count + 1
    else
      count
    end

    count_increases(tail, head, new_count)
  end

  # version of the function to run when list is empty
  defp count_increases([], _previous_value, count) do
    IO.puts "Num. of increases: #{count}"
  end

  defp count_for_sliding_window(data, previous_value, count \\ 0)

  # wonder how I could make this dynamic
  defp count_for_sliding_window([a, b, c | rem], previous_value, count) do
    current_value = a + b + c

    new_count = if current_value > previous_value do
      count + 1
    else
      count
    end

    count_for_sliding_window([b, c] ++ rem, current_value, new_count)
  end

  # version of the function to run when list no longer has a window of three
  defp count_for_sliding_window([_a, _b | []], _previous_value, count) do
    IO.puts "Num. of window increases: #{count}"
  end
end

IO.puts("Calculating...")
AdventDayOne.solution()
