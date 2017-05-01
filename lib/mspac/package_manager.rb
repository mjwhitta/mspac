require "scoobydoo"

class MsPac::PackageManager
    attr_reader :mspac
    attr_reader :pkgmgr

    def alt_install(packages, pkgmgr = @pkgmgr)
        return if (packages.nil?)
        packages.each do |pkg|
            pkgmgr_install(pkg, pkgmgr)
        end
    end

    def initialize(mspac)
        @mspac = mspac

        if (ScoobyDoo.where_are_you("apt-get"))
            @pkgmgr = "apt-get"
        elsif (ScoobyDoo.where_are_you("brew"))
            raise MsPac::Error::UnsupportedPackageManager.new(
                "brew"
            )
        elsif (ScoobyDoo.where_are_you("pacman"))
            @pkgmgr = "pacman"
        elsif (ScoobyDoo.where_are_you("yum"))
            raise MsPac::Error::UnsupportedPackageManager.new(
                "yum"
            )
        elsif (ScoobyDoo.where_are_you("zipper"))
            raise MsPac::Error::UnsupportedPackageManager.new(
                "zipper"
            )
        else
            raise MsPac::Error::UnsupportedPackageManager.new
        end
    end

    def install(packages, pkgmgr = @pkgmgr)
        return if (packages.nil?)
        pkgmgr_install(packages.join(" "), pkgmgr)
    end

    def pkgmgr_install(pkgs, pkgmgr = @pkgmgr)
        return if (pkgs.nil? || pkgs.empty?)
        case pkgmgr
        when "apt-get"
            system("sudo apt-get install -y #{pkgs}")
        when "brew"
            raise MsPac::Error::UnsupportedPackageManager.new(
                "brew"
            )
        when "mspac"
            @mspac.install(pkgs.split(" "))
        when "pacman"
            system("sudo pacman --needed --noconfirm -S #{pkgs}")
        when "perl"
            system("umask 022 && sudo cpan #{pkgs}")
        when "python2"
            system("umask 022 && sudo python2 -m pip install #{pkgs}")
        when "python3"
            system("umask 022 && sudo python3 -m pip install #{pkgs}")
        when "yum"
            raise MsPac::Error::UnsupportedPackageManager.new(
                "yum"
            )
        when "zipper"
            raise MsPac::Error::UnsupportedPackageManager.new(
                "zipper"
            )
        else
            raise MsPac::Error::UnsupportedPackageManager.new
        end
    end
    private :pkgmgr_install
end
