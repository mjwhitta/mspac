class MsPac::Error::PelletRepo < MsPac::Error
    def initialize
        super("Could not update pellet repo")
    end
end
