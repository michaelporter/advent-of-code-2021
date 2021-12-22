defmodule AdventDayThree do
  def solution do
    codes = get_data("day-three/binary_codes.txt")
    codes_as_arrays = break_out_codes_to_array(codes)

    get_power_rates(codes_as_arrays)
    get_life_support_rating(codes_as_arrays)
  end

  defp get_power_rates(codes) do
    gamma_rate = get_gamma_rate(codes)
    epsilon_rate = get_epsilon_rate(gamma_rate)

    int_gamma = convert_back_to_int(gamma_rate)
    int_epsilon = convert_back_to_int(epsilon_rate)

    IO.puts "Power Consumption: #{int_gamma * int_epsilon}"
  end

  defp get_life_support_rating(codes_as_arrays) do
    # would be dope to get both in the same invocation
    oxy_rating = get_life_rating(codes_as_arrays, &(&1 >= &2 / 2))
    co2_rating = get_life_rating(codes_as_arrays, &(&1 < &2 / 2))

    IO.puts "Life Support Rating: #{oxy_rating * co2_rating}"
  end

  # set default value for index
  defp get_life_rating(codes_as_arrays, fun, index \\ 0)

  # when we have whittled down to a single code
  defp get_life_rating([remaining_code], _fun, _index) do
    # format the code now
    convert_back_to_int(remaining_code)
  end

  defp get_life_rating(codes_as_arrays, fun, index) do
    number_of_codes = length(codes_as_arrays)
    position_sums = map_position_sums(codes_as_arrays)
    current_bit_ones_count = Enum.at(Tuple.to_list(position_sums), index)

    value_to_match = if fun.(current_bit_ones_count, number_of_codes), do: 1, else: 0

    remaining_codes = Enum.filter(
      codes_as_arrays,
      fn code_array -> Enum.at(code_array, index) == value_to_match end
    )

    get_life_rating(remaining_codes, fun, index + 1)
  end

  defp get_gamma_rate(codes_as_arrays) do
    number_of_codes = length(codes_as_arrays)
    position_sums = map_position_sums(codes_as_arrays)
    compare_fun = &(&1 > number_of_codes / 2)

    Enum.map(Tuple.to_list(position_sums), fn s ->
      if compare_fun.(s), do: 1, else: 0
    end)
  end

  defp get_epsilon_rate(gamma_rate) do
    Enum.map(gamma_rate, fn g ->
      if g == 1, do: 0, else: 1
    end)
  end

  defp break_out_codes_to_array(codes) do
    split_codes = Enum.map(codes, fn x -> String.split(x, "", trim: true) end)
    # an array of arrays of single chars
    Enum.map(split_codes, fn code ->
      Enum.map(code, fn pos ->
        {num, _str} = Integer.parse(pos)
        num
      end)
    end)
  end

  defp map_position_sums(codes_as_arrays) do
    # collects the values in each position of the string into their own list,
    # and adds them to a "master tuple" that represents the count of 1s in that position
    Enum.zip_reduce(
      codes_as_arrays,
      {},
      fn position, acc ->
        # IO.puts inspect(acc, charlists: :as_list)
        Tuple.append(acc, Enum.sum(position))
      end
    )
  end

  defp convert_back_to_int(rate_array) do
    String.to_integer(List.to_string(Enum.map(rate_array, fn x -> "#{x}" end)), 2)
  end


  defp get_data(filename) do
    {:ok, cwd} = File.cwd()

    case File.read("#{cwd}/#{filename}") do
      {:ok, body} -> parse_data(body)
      {:error, reason} -> IO.puts(reason)
    end
  end

  defp parse_data(body) do
    String.split(body, "\r\n", trim: true) # keep the data as strings
  end
end

AdventDayThree.solution()
