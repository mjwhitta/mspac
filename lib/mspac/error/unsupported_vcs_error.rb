class MsPac::Error::UnsupportedVCSError < MsPac::Error
    def initialize(vcs = "unknown")
        super("Unsupported version control system: #{vcs}")
    end
end
