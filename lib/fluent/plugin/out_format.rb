module Fluent
  class FormatOutput < Output
    Fluent::Plugin.register_output('format', self)

    # Define `router` method of v0.12 to support v0.10 or earlier
    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

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

    def emit(tag, es, chain)
      es.each do |time, record|
        router.emit(@tag, time, format_record(record))
      end

      chain.next
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