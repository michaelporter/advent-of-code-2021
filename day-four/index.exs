# This one def did not get a pass for beauty yet, but we got there

defmodule AdventDayFour do
  def solution do
    {call_order, bingo_cards} = get_data("day-four/squid_bingo_small.txt")

    call_the_numbers(call_order, bingo_cards, [], nil)
  end

  defp announce_winner(winning_card, final_number) do

    get_uncalled_cells = fn cell ->
      case cell do
        { _n, :uncalled } -> true
        _ -> false
      end
    end

    bonkers_function = fn row ->
      row 
        |> Enum.filter(get_uncalled_cells) 
        |> Enum.map(&(Tuple.to_list(&1) |> Enum.at(0))) 
        |> Enum.sum
    end

    summed = winning_card |> Enum.map(bonkers_function) |> Enum.sum

    IO.puts inspect(summed)

    IO.puts "Final #{summed} x #{final_number} = #{summed * final_number}"
    winning_card
  end

  defp call_the_numbers(numbers, cards, called_numbers, latest_winner, winning_number \\ 0)

  defp call_the_numbers([], _cards, [_head | _tail], latest_winner, winning_number) do
    announce_winner(latest_winner, winning_number)
  end

  defp call_the_numbers([called_number|tail], cards, called_numbers, latest_winner, winning_number) do
    updated_cards = Enum.map(
      cards,
      fn card -> check_and_update_card(called_number, card) end
    )

    winning_cards = Enum.filter(
      updated_cards,
      fn card -> is_winner?(card, [called_number | called_numbers]) end
    )

    # also remove all the winning cards from the pile - not ideal to loop twice!
    remaining_cards = Enum.filter(
      updated_cards,
      fn card -> !is_winner?(card, [called_number | called_numbers]) end
    )

    if length(winning_cards) > 0 do
      call_the_numbers(tail, remaining_cards, [called_number | called_numbers], List.last(winning_cards), called_number)
    else
      call_the_numbers(tail, updated_cards, [called_number | called_numbers], latest_winner, winning_number)
    end
  end

  defp check_and_update_card(called_number, card) do
    iterate_cells = fn {num, state} ->
      case {num, state} do
        {^called_number, :uncalled} ->
          {num, :called}
        _ ->
          {num, state}
      end
    end

    iterate_rows = &(Enum.map(&1, iterate_cells))

    Enum.map(card, iterate_rows)
  end

  defp is_winner?(card, _called_numbers) do
    winning_cells = fn cell ->
      case cell do
        {_n, :uncalled} -> false
        {_n, :called} -> true
      end
    end

    winning_row = fn row ->
      winning_cells_count = row |> Enum.filter(winning_cells) |> length 
      winning_cells_count == row |> length
    end

    winning_column = fn col ->
      winning_cells_count =  col |> Tuple.to_list |> Enum.filter(winning_cells) |> length
      winning_cells_count == col |> Tuple.to_list |> length
    end

    row_winner    = card |> Enum.find(winning_row)
    column_winner = card |> Enum.zip |> Enum.find(winning_column)

    row_winner || column_winner
  end

  defp get_data(filename) do
    {:ok, cwd} = File.cwd()

    case File.read("#{cwd}/#{filename}") do
      {:ok, body} -> parse_data(body)
      {:error, reason} -> IO.puts(reason)
    end
  end

  defp parse_data(body) do
    [called_numbers | card_data] = String.split(body, ~r/\n\n/, trim: true) # keep the data as strings

    {
      called_numbers 
        |> String.split(~r/,|\r|\n/, trim: true) 
        |> Enum.map(&(String.to_integer(&1))),
      parse_bingo_cards(card_data)
    }
  end

  defp parse_bingo_cards(lines, cards \\ [])

  defp parse_bingo_cards([], cards) do
    cards
  end

  defp parse_bingo_cards([card|remaining_cards], cards) do
    map_cell_data = &({String.to_integer(&1), :uncalled})
    parse_row = &(
      &1 
        |> String.split(~r/\s+/, trim: true) 
        |> Enum.map(map_cell_data)
    )

    new_card = String.split(card, ~r/\n/, trim: true) |> Enum.map(parse_row)

    parse_bingo_cards(remaining_cards, [new_card | cards])
  end
end

AdventDayFour.solution()
