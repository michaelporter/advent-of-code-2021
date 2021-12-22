# personal goals for this one -
# - gain comfort with debugging techniques in Elixir
# - use the Pipe operator to mahe data transforms more obvious
# - use the Stream functions to optimize resource usage on transforms
# - use imports to make the file reading code shared between my solutions. let it accept a dynamic parsing function

# likely goals for next one -
# - utilize typedoc typechecks
# - utilize a unit test library


defmodule AdventDayFive do
  def solution do
    # get_data("day-five/input-data.txt")
    IO.puts "Day Five"
  end

  defp get_data(filename) do
    {:ok, cwd} = File.cwd()

    case File.read("#{cwd}/#{filename}") do
      {:ok, body} -> parse_data(body)
      {:error, reason} -> IO.puts(reason)
    end
  end

  defp parse_data(body) do
    String.split(body, ~r/\r\n/, trim: true)
  end
end

AdventDayFive.solution()
