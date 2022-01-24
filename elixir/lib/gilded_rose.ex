defmodule GildedRose do
  @spec update_quality(any) :: list
  @doc """
      Update GildedRose collection

      ## Examples

        iex> GildedRose.update_quality([%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 1}])
        [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 3}]
  """
  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  defp increase_quality(%Item{} = item) do
    %{item | quality: item.quality + 1}
  end

  defp decrease_quality(%Item{} = item) do
    decrease_attribute(item, :quality)
  end

  defp decrease_attribute(%Item{} = item, attribute) do
    %{item | attribute => Map.get(item, attribute) - 1}
  end

  @spec update_item(atom | %{:name => String.t(), :quality => integer(), optional(any) => any}) ::
          atom | %{:name => String.t(), :quality => integer(), :sell_in => integer(), optional(any) => any}
  def update_item(item) do
    item = cond do
      item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" ->
        if item.name != "Sulfuras, Hand of Ragnaros" && item.quality > 0 do
          decrease_quality(item)
        else
          item
        end
      true ->
        cond do
          item.quality < 50 ->
            item = increase_quality(item)
            cond do
              item.name == "Backstage passes to a TAFKAL80ETC concert" ->
                cond do
                  item.sell_in < 11 ->
                    cond do
                      item.quality < 50 ->
                        increase_quality(item)
                      true -> item
                    end
                  true -> item
                end
              true -> item
            end
          true -> item
        end
    end
    item = cond do
      item.name != "Sulfuras, Hand of Ragnaros" ->
        item |> decrease_attribute(:sell_in)
      true -> item
    end
    cond do
      item.sell_in < 0 ->
        cond do
          item.name != "Aged Brie" ->
            cond do
              item.name != "Backstage passes to a TAFKAL80ETC concert" ->
                cond do
                  item.quality > 0 ->
                    cond do
                      item.name != "Sulfuras, Hand of Ragnaros" ->
                        decrease_quality(item)
                      true -> item
                    end
                  true -> item
                end
              true -> %{item | quality: item.quality - item.quality}
            end
          true ->
            cond do
              item.quality < 50 ->
                increase_quality(item)
              true -> item
            end
        end
      true -> item
    end
  end
end
