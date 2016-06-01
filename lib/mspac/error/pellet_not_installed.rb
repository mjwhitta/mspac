class MsPac::Error::PelletNotInstalled < MsPac::Error
    def initialize(pellet = "unknown")
        super("Pellet not installed: #{pellet}")
    end
end
