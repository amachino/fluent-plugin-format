require 'fluent/test'
require 'fluent/test/driver/output'
require 'fluent/test/helpers'
require 'fluent/plugin/out_format'

class FormatOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::FormatOutput).configure(conf)
  end

  def test_format
    d1 = create_driver %[
      type format
      tag formatted
      key1 %{key1} changed!
      new_key1 key1 -> %{key1}
      new_key2 key1 -> %{key1}, key2 -> %{key2}
    ]

    d1.run(default_tag: 'test') do
      d1.feed({'key1' => 'val1', 'key2' => 'val2'})
      d1.feed({'key1' => 'val1'})
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
    ], d1.events.map{|e| e.last}

    d2 = create_driver %[
      type format
      tag formatted
      include_original_fields true
      key1 %{key1} changed!
      new_key1 key1 -> %{key1}
      new_key2 key1 -> %{key1}, key2 -> %{key2}
    ]

    d2.run(default_tag: 'test') do
      d2.feed({'key1' => 'val1', 'key2' => 'val2'})
      d2.feed({'key1' => 'val1'})
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
    ], d2.events.map{|e| e.last}

    d3 = create_driver %[
      type format
      tag formatted
      include_original_fields false
      key1 %{key1} changed!
      new_key1 key1 -> %{key1}
      new_key2 key1 -> %{key1}, key2 -> %{key2}
    ]

    d3.run(default_tag: 'test') do
      d3.feed({'key1' => 'val1', 'key2' => 'val2'})
      d3.feed({'key1' => 'val1'})
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
    ], d3.events.map{|e| e.last}
  end
end
