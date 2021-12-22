# This one def did not get a pass for beauty yet, but we got there

defmodule AdventDayFour do
  def solution do
    {call_order, bingo_cards} = get_data("day-four/squid_bingo.txt")

    call_the_numbers(call_order, bingo_cards, [], nil)
  end

  defp announce_winner(winning_card, final_number) do
    summed = Enum.sum(
      Enum.map(
        winning_card,
        fn row ->
          Enum.reduce(
            Enum.filter(row, fn cell ->
              case cell do
                { _n, :uncalled } -> true
                _ -> false
              end
            end),
            0,
            fn ({num, _status}, acc)->
              num + acc
            end
          )
        end))

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
    Enum.map(
      card,
      fn row ->
        Enum.map(row, fn {num, state} ->
          case {num, state} do
            {^called_number, :uncalled} ->
              {num, :called}
            _ ->
              {num, state}
          end
        end)
      end
    )
  end

  defp is_winner?(card, _called_numbers) do
    row_winner = Enum.find(
      card, # [[{}], [], []]
      fn row ->
        length(Enum.filter(row, fn cell ->
          case cell do
            {_n, :uncalled} -> false
            {_n, :called} -> true
          end
        end))== length(row)
      end
    )

    column_winner = Enum.find(
      Enum.zip(card),
      fn col ->
        length(Enum.filter(Tuple.to_list(col), fn cell ->
          case cell do
            {_n, :uncalled} -> false
            {_n, :called} -> true
          end
        end)) == tuple_size(col)
      end)

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
    [called_numbers | card_data] = String.split(body, ~r/\n\r/, trim: true) # keep the data as strings

    {
      Enum.map(String.split(called_numbers, ~r/,|\r|\n/, trim: true), fn n -> String.to_integer(n) end),
      parse_bingo_cards(card_data)
    }
  end

  defp parse_bingo_cards(lines, cards \\ [])

  defp parse_bingo_cards([], cards) do
    cards
  end

  defp parse_bingo_cards([card|remaining_cards], cards) do
    rows = String.split card, ~r/\r|\n/, trim: true

    new_card = Enum.map(
      rows,
      fn row ->
        Enum.map(
          String.split(row, ~r/\s+/, trim: true),
          fn i -> {String.to_integer(i), :uncalled} end
        )
      end
    )

    parse_bingo_cards(remaining_cards, [new_card | cards])
  end
end

AdventDayFour.solution()
