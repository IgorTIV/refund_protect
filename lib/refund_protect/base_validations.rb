module RefundProtect
  module BaseValidations
    attr_reader :errors

    def valid?(recheck = false)
      if recheck || !@errors.is_a?(Hash)
        @errors = Hash.new
        run_validations
      end

      @errors.keys.empty?
    end

    def invalid?(recheck = false)
      !valid?(recheck)
    end

    def run_validations
    end

    private

    def validates_presence_of(key)
      value = public_send(key)

      if value.nil? || value.empty?
        add_error(key, :blank)
      end
    end

    def validates_object_class_of(key, klass)
      value = public_send(key)

      unless value.is_a?(klass)
        add_error(key, :invalid)
      end
    end

    def validates_inclusion_in(key, inclusion_list)
      value = public_send(key)

      unless inclusion_list.include?(value)
        add_error(key, :invalid)
      end
    end

    def validates_nested_array_of(key)
      value = public_send(key)

      return add_error(key, :invalid) if !value.is_a?(Array) || value.empty?

      value.each do |nested|
        nested.invalid?
      end

      unless value.all?(&:valid?)
        add_error(key, :invalid)
      end
    end

    def add_error(key, error)
      @errors ||= {}
      @errors[key] = (@errors[key] ||= []) << error_message(error)
    end

    def error_message(error)
      case error
      when :blank
        "can't be blank"
      when :invalid
        'is invalid'
      else
        error
      end
    end
  end
end
