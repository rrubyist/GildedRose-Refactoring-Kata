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
    if item.name == "Sulfuras, Hand of Ragnaros" do
      item
    else
      %{item | attribute => Map.get(item, attribute) - 1}
    end
  end

  @spec update_item(atom | %{:name => String.t(), :quality => integer(), optional(any) => any}) ::
          atom | %{:name => String.t(), :quality => integer(), :sell_in => integer(), optional(any) => any}
  def update_item(item) do
    item = case item.name do
      name when name in ["Aged Brie", "Backstage passes to a TAFKAL80ETC concert"] ->
        item = increase_quality(item)
        if item.name == "Backstage passes to a TAFKAL80ETC concert" do
          item = if item.sell_in < 11, do: increase_quality(item), else: item
          if item.sell_in < 6, do: increase_quality(item), else: item
        else
          item
        end
      _ -> decrease_quality(item)
      end
    item = item |> decrease_attribute(:sell_in)
    cond do
      item.sell_in < 0 ->
        case item.name do
          "Aged Brie" ->
            increase_quality(item)
          _ ->
            cond do
              item.name != "Backstage passes to a TAFKAL80ETC concert" ->
                decrease_quality(item)
              true ->
                %{item | quality: item.quality - item.quality}
            end
        end
      true -> item
    end
  end
end
