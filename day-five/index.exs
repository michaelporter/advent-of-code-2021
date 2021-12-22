# personal goals for this one -
# - gain comfort with debugging techniques in Elixir
# - use the Pipe operator to mahe data transforms more obvious
# - use the Stream functions to optimize resource usage on transforms

# likely goals for next one -
# - utilize typedoc typechecks
# - utilize a unit test library


defmodule AdventDayFour do
  def solution do
    {call_order, bingo_cards} = get_data("day-four/squid_bingo.txt")

    call_the_numbers(call_order, bingo_cards, [], nil)
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

AdventDayFour.solution()
