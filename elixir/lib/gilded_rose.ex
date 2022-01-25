defmodule GildedRose do
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
    if item.quality < 50 do
      %{item | quality: item.quality + 1}
    else
      item
    end
  end

  defp decrease_quality(%Item{} = item) do
    if item.quality > 0 do
      decrease_attribute(item, :quality)
    else
      item
    end
  end

  defp decrease_attribute(%Item{} = item, attribute) do
    %{item | attribute => Map.get(item, attribute) - 1}
  end

  defp update_item(%Item{name: "Backstage passes to a TAFKAL80ETC concert"} = item) do
    item = increase_quality(item) |> decrease_attribute(:sell_in)

    item = if item.sell_in < 11, do: increase_quality(item), else: item
    item = if item.sell_in < 6, do: increase_quality(item), else: item

    if item.sell_in < 0,
      do: %{item | quality: item.quality - item.quality},
      else: item
  end

  defp update_item(%Item{name: "Aged Brie"} = item) do
    item = increase_quality(item) |> decrease_attribute(:sell_in)

    if item.sell_in < 0,
      do: increase_quality(item),
      else: item
  end

  defp update_item(%Item{name: "Sulfuras, Hand of Ragnaros"} = item) do
    item
  end

  defp update_item(%Item{} = item) do
    item = decrease_quality(item) |> decrease_attribute(:sell_in)

    if item.sell_in < 0,
      do: decrease_quality(item),
      else: item
  end
end
