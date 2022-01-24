defmodule GildedRoseTest do
  use ExUnit.Case
  doctest(GildedRose)

  # test "update_quality" do
  #   items = GildedRose.update_quality(
  #     [%Item{name: "foo", sell_in: 0, quality: 0}]
  #   )
  #   %{name: name} = List.first(items)

  #   assert "foo" == name
  # end

  describe "when it has well recognized names" do
    test "the sell_in and the quality stays on its position" do
      items = [%Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 0}]
      [item] = GildedRose.update_quality(items)

      assert item.quality == 0
      assert item.sell_in == 0
    end

    test "sell_in < 11 and quality < 50" do
      items = [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 49}]
      [item] = GildedRose.update_quality(items)

      assert item.quality == 50
      assert item.sell_in == 9
    end

    test "sell_in < 6 and quality < 50" do
      items = [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 49}]
      [item] = GildedRose.update_quality(items)

      assert item.quality == 50
      assert item.sell_in == 4
    end

    test "sell_in < 11 and quality > 50" do
      items = [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 51}]
      [item] = GildedRose.update_quality(items)

      assert item.quality == 51
      assert item.sell_in == 9
    end
  end

  describe "when it has unrecognized name" do
    # test "drops the price 123" do
    #   items = [%Item{name: "Unrecognized name", sell_in: 0, quality: 49}]
    #   [item] = GildedRose.update_quality(items)

    #   assert item.quality == 0
    #   assert item.sell_in == -1
    # end

    test "drops the price" do
      items = [%Item{name: "Unrecognized name", sell_in: 0, quality: 0}]
      [item] = GildedRose.update_quality(items)

      assert item.quality == 0
      assert item.sell_in == -1
    end

    test "loses the sell_in and the quality points" do
      items = [%Item{name: "Unrecognized name", sell_in: 10, quality: 1}]
      [item] = GildedRose.update_quality(items)

      assert item.quality == 0
      assert item.sell_in == 9
    end
  end


end
