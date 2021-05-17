module RefundProtect
  class Error < StandardError
  end

  class RequestInvalid < Error
  end

  class ResponseInvalid < Error
  end
end
