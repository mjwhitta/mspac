require "scoobydoo"

class MsPac::PackageManager
    attr_reader :pkgmgr

    def alt_install(packages, pkgmgr = @pkgmgr)
        return if (packages.nil? || packages.empty?)
        packages.each do |pkg|
            pkgmgr_install(pkg, pkgmgr)
        end
    end

    def initialize
        if (ScoobyDoo.where_are_you("apt-get"))
            @pkgmgr = "apt-get"
        elsif (ScoobyDoo.where_are_you("brew"))
            raise Error::UnsupportedPackageManagerError.new("brew")
        elsif (ScoobyDoo.where_are_you("pacman"))
            @pkgmgr = "pacman"
        elsif (ScoobyDoo.where_are_you("yum"))
            raise Error::UnsupportedPackageManagerError.new("yum")
        elsif (ScoobyDoo.where_are_you("zipper"))
            raise Error::UnsupportedPackageManagerError.new("zipper")
        else
            raise Error::UnsupportedPackageManagerError.new
        end
    end

    def install(packages, pkgmgr = @pkgmgr)
        return if (packages.nil? || packages.empty?)
        pkgmgr_install(packages.join(" "), pkgmgr)
    end

    def pkgmgr_install(pkgs, pkgmgr = @pkgmgr)
        case pkgmgr
        when "apt-get"
            system("sudo apt-get install -y #{pkgs}")
        when "brew"
            raise Error::UnsupportedPackageManagerError.new("brew")
        when "pacman"
            system("sudo pacman --needed --noconfirm -S #{pkgs}")
        when "perl"
            system("umask 022 && sudo cpan #{pkgs}")
        when "python2"
            system("umask 022 && sudo python2 -m pip install #{pkgs}")
        when "python3"
            system("umask 022 && sudo python3 -m pip install #{pkgs}")
        when "yum"
            raise Error::UnsupportedPackageManagerError.new("yum")
        when "zipper"
            raise Error::UnsupportedPackageManagerError.new("zipper")
        else
            raise Error::UnsupportedPackageManagerError.new
        end
    end
    private :pkgmgr_install
end
