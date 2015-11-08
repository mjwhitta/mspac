class MsPac::Error::InvalidOperationError < MsPac::Error
    def initialize(op = "")
        super("Unsupported operation: #{op}")
    end
end
