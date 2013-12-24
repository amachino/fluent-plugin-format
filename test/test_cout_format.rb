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
      include_original_fields false
      field1 field1 is %{key1}.
      field2 field2 is %{key2}.
    ]

    d1.run do
      d1.emit({'key1' => 'val1', 'key2' => 'val2'})
      d1.emit({'key1' => 'val1'})
    end

    d2 = create_driver %[
      type format
      tag formatted
      include_original_fields true
      field1 field1 is %{key1}.
      field2 field2 is %{key2}.
    ]

    d2.run do
      d2.emit({'key1' => 'val1', 'key2' => 'val2'})
      d2.emit({'key1' => 'val1'})
    end

    d3 = create_driver %[
      type format
      tag formatted
      field1 field1 is %{key1}.
      field2 field2 is %{key2}.
    ]

    d3.run do
      d3.emit({'key1' => 'val1', 'key2' => 'val2'})
      d3.emit({'key1' => 'val1'})
    end

    assert_equal d1.records, [
      {'field1' => 'field1 is val1.', 'field2' => 'field2 is val2.'},
      {'field1' => 'field1 is val1.', 'field2' => 'field2 is .'}
    ]
    assert_equal d2.records, [
      {'key1' => 'val1', 'key2' => 'val2', 'field1' => 'field1 is val1.', 'field2' => 'field2 is val2.'},
      {'key1' => 'val1', 'field1' => 'field1 is val1.', 'field2' => 'field2 is .'}
    ]
    assert_equal d3.records, [
      {'key1' => 'val1', 'key2' => 'val2', 'field1' => 'field1 is val1.', 'field2' => 'field2 is val2.'},
      {'key1' => 'val1', 'field1' => 'field1 is val1.', 'field2' => 'field2 is .'}
    ]
  end
end
