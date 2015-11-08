class MsPac::Error::UnsupportedPackageManagerError < MsPac::Error
    def initialize(pkg_mgr = "unknown")
        super("Unsupported package manager: #{pkg_mgr}")
    end
end
