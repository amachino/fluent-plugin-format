require 'fluent/plugin/output'

module Fluent::Plugin
  class FormatOutput < Output
    Fluent::Plugin.register_output('format', self)

    helpers :event_emitter

    config_param :tag, :string
    config_param :include_original_fields, :bool, :default => true

    CONF_KEYS = %w{type tag include_original_fields}

    def configure(conf)
      super

      @fields = {}
      conf.each do |k, v|
        unless CONF_KEYS.include?(k)
          @fields[k] = v
        end
      end
    end

    def process(tag, es)
      es.each do |time, record|
        router.emit(@tag, time, format_record(record))
      end
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
