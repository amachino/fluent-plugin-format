require 'fluent/plugin/output'

module Fluent::Plugin
  class FormatOutput < Output
    Fluent::Plugin.register_output('format', self)

    helpers :event_emitter

    DEFAULT_BUFFER_TYPE = "memory"

    config_param :tag, :string
    config_param :include_original_fields, :bool, :default => true
    config_param :buffered, :bool, :default => false

    config_section :buffer do
      config_set_default :@type, DEFAULT_BUFFER_TYPE
    end

    CONF_KEYS = %w{type tag include_original_fields buffered}

    def configure(conf)
      super

      @fields = {}
      conf.each do |k, v|
        unless CONF_KEYS.include?(k)
          @fields[k] = v
        end
      end
    end

    def prefer_buffered_processing
      @buffered
    end

    def formatted_to_msgpack_binary?
      true
    end

    def multi_workers_ready?
      true
    end

    def format(tag, time, record)
      [time, record].to_msgpack
    end

    def process(tag, es)
      es.each do |time, record|
        router.emit(@tag, time, format_record(record))
      end
    end

    def write(chunk)
      chunk.msgpack_each {|time, record|
        router.emit(@tag, time, format_record(record))
      }
    end

    private

    def format_record(record)
      result = {}

      if @include_original_fields
        result.merge!(record)
      end

      @fields.each do |k, v|
        result[k] = v.gsub(/%{(.+?)}/).each { record[$1] }
      end

      return result
    end
  end
end
