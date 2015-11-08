class MsPac::Error::PelletRepoError < MsPac::Error
    def initialize
        super("Could not update pellet repo")
    end
end
