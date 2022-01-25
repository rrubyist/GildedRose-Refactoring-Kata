defmodule GildedRoseTest do
  use ExUnit.Case
  doctest(GildedRose)

  describe "Aged Brie" do
    # "Aged Brie" actually increases in Quality by 2 if negative it gets
    test "sell_in: 0, quality: 0", context do
      items = [%Item{name: context.describe, sell_in: 0, quality: 0}]
      [item] = GildedRose.update_quality(items)

      assert item.quality == 2
      assert item.sell_in == -1
    end

    # "Aged Brie" actually increases in Quality the older it gets
    test "sell_in: 3, quality: 3", context do
      items = [%Item{name: context.describe, sell_in: 3, quality: 3}]
      [item] = GildedRose.update_quality(items)

      assert item.quality == 4
      assert item.sell_in == 2
    end
  end

  # "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
  describe "Sulfuras, Hand of Ragnaros" do
    test "sell_in: 3, quality: 3", context do
      items = [%Item{name: context.describe, sell_in: 3, quality: 3}]
      [item] = GildedRose.update_quality(items)

      assert item.quality == 3
      assert item.sell_in == 3
    end
  end

  describe "Backstage passes to a TAFKAL80ETC concert" do
    test "sell_in: 10, quality: 49", context do
      items = [%Item{name: context.describe, sell_in: 10, quality: 49}]
      [item] = GildedRose.update_quality(items)

      assert item.sell_in == 9
      assert item.quality == 50
    end

    # The Quality of an item is never more than 50
    test "sell_in: 10, quality: 50", context do
      items = [%Item{name: context.describe, sell_in: 10, quality: 50}]
      [item] = GildedRose.update_quality(items)

      assert item.sell_in == 9
      assert item.quality == 50
    end

    test "sell_in -5, quality: 5", context do
      items = [%Item{name: context.describe, sell_in: -5, quality: 5}]
      [item] = GildedRose.update_quality(items)

      assert item.sell_in == -6
      assert item.quality == 0
    end

    # Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less
    # but Quality drops to 0 after the concert

    test "sell_in 10, quality: 0", context do
      items = [%Item{name: context.describe, sell_in: 10, quality: 0}]
      [item] = GildedRose.update_quality(items)

      assert item.sell_in == 9
      assert item.quality == 2

      items = [%Item{name: context.describe, sell_in: 5, quality: 0}]
      [item] = GildedRose.update_quality(items)

      assert item.sell_in == 4
      assert item.quality == 3

      items = [%Item{name: context.describe, sell_in: 0, quality: 5}]
      [item] = GildedRose.update_quality(items)

      assert item.sell_in == -1
      assert item.quality == 0
    end
  end

  describe "unrecognized name" do
    # Once the sell by date has passed, Quality degrades twice as fast
    test "sell_in: -1, quality: 5", context do
      items = [%Item{name: context.describe, sell_in: -1, quality: 3}]
      [item] = GildedRose.update_quality(items)

      assert item.sell_in == -2
      assert item.quality == 1
    end

    # The Quality of an item is never negative
    test "sell_in: -5, quality: 1", context do
      items = [%Item{name: context.describe, sell_in: -1, quality: 1}]
      [item] = GildedRose.update_quality(items)

      assert item.sell_in == -2
      assert item.quality == 0
    end

    test "sell_in: 0, quality: 0", context do
      items = [%Item{name: context.describe, sell_in: 0, quality: 0}]
      [item] = GildedRose.update_quality(items)

      assert item.sell_in == -1
      assert item.quality == 0
    end

    test "sell_in: 10, quality: 1", context do
      items = [%Item{name: context.describe, sell_in: 10, quality: 1}]
      [item] = GildedRose.update_quality(items)

      assert item.sell_in == 9
      assert item.quality == 0
    end
  end


end
