require 'fluent/test'
require 'fluent/plugin/out_format'

class FormatOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf)
    Fluent::Test::OutputTestDriver.new(Fluent::FormatOutput).configure(conf)
  end

  def test_format
    d1 = create_driver %[
      type format
      tag formatted
      key1 %{key1} changed!
      new_key1 key1 -> %{key1}
      new_key2 key1 -> %{key1}, key2 -> %{key2}
    ]

    d1.run do
      d1.emit({'key1' => 'val1', 'key2' => 'val2'})
      d1.emit({'key1' => 'val1'})
    end

    assert_equal [
      {
        'key1' => 'val1 changed!',
        'key2' => 'val2',
        'new_key1' => 'key1 -> val1',
        'new_key2' => 'key1 -> val1, key2 -> val2'
      },
      {
        'key1' => 'val1 changed!',
        'new_key1' => 'key1 -> val1',
        'new_key2' => 'key1 -> val1, key2 -> '
      }
    ], d1.records

    d2 = create_driver %[
      type format
      tag formatted
      include_original_fields true
      key1 %{key1} changed!
      new_key1 key1 -> %{key1}
      new_key2 key1 -> %{key1}, key2 -> %{key2}
    ]

    d2.run do
      d2.emit({'key1' => 'val1', 'key2' => 'val2'})
      d2.emit({'key1' => 'val1'})
    end

    assert_equal [
      {
        'key1' => 'val1 changed!',
        'key2' => 'val2',
        'new_key1' => 'key1 -> val1',
        'new_key2' => 'key1 -> val1, key2 -> val2'
      },
      {
        'key1' => 'val1 changed!',
        'new_key1' => 'key1 -> val1',
        'new_key2' => 'key1 -> val1, key2 -> '
      }
    ], d2.records

    d3 = create_driver %[
      type format
      tag formatted
      include_original_fields false
      key1 %{key1} changed!
      new_key1 key1 -> %{key1}
      new_key2 key1 -> %{key1}, key2 -> %{key2}
    ]

    d3.run do
      d3.emit({'key1' => 'val1', 'key2' => 'val2'})
      d3.emit({'key1' => 'val1'})
    end

    assert_equal [
      {
        'key1' => 'val1 changed!',
        'new_key1' => 'key1 -> val1',
        'new_key2' => 'key1 -> val1, key2 -> val2'
      },
      {
        'key1' => 'val1 changed!',
        'new_key1' => 'key1 -> val1',
        'new_key2' => 'key1 -> val1, key2 -> '
      }
    ], d3.records
  end
end
