class MsPac::Error::MissingPelletError < MsPac::Error
    def initialize(pellet = nil)
        if (pellet)
            super("Pellet not found: #{pellet}")
        else
            super("No pellets specified")
        end
    end
end
