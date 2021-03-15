defmodule Crc do
  def test() do
    generator = [1, 0, 1, 1]
    sequence = [1,1,0,1,0,1,0,1,1,1,0,1,0,0,1,0,1]
    crc(sequence ++ [0,0,0], generator)
  end

  @spec crc(maybe_improper_list, any) :: maybe_improper_list
  def crc(seq, generator) do
    cond do
      len(seq) == 3 ->
        seq
      hd(seq) == 0 ->
        crc(tl(seq), generator)
      true ->
        crc(four_xor(seq, generator), generator)
    end
  end

  def len([]) do 0 end
  def len(list) do len(tl(list), 1) end

  def len([], length) do length end
  def len(list, length) do len(tl(list), length + 1) end


  def four_xor(seq, []) do seq end
  def four_xor(seq, [poll|rest]) do
    cond do
      hd(seq) == poll ->
        [0|four_xor(tl(seq), rest)]
      true ->
        [1|four_xor(tl(seq), rest)]
    end
  end
end
