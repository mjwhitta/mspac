class MsPac::Error::MultipleOperationsError < MsPac::Error
    def initialize
        super("Too many operations were specified")
    end
end
