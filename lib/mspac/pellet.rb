require "colorize"
require "fileutils"

class MsPac::Pellet < Hash
    @@cache_dir = Pathname("~/.mspac/cache").expand_path
    @@install_dir = Pathname("~/.mspac/installed").expand_path

    def initialize(json)
        json.keys.each do |key|
            self[key] = json[key]
        end

        @pm = MsPac::PackageManager.new
        @vcs = MsPac::VersionControl.new(self["vcs"])
    end

    def cached?
        Pathname.new("#{@@cache_dir}/#{name}").expand_path.exist?
    end

    def compile
        return if (self["compile"].empty?)
        puts "Compiling #{name}...".white
        execute("compile")
    end
    private :compile

    def desc
        return self["desc"]
    end

    def execute(operation)
        Dir.chdir("#{@@install_dir}/#{name}") do
            system(["umask 022"].concat(self[operation]).join("; "))
        end if (!self[operation].empty?)
    end
    private :execute

    def fetch
        FileUtils.mkdir_p(@@cache_dir)
        FileUtils.mkdir_p(@@install_dir)

        get_deps

        puts "Fetching #{name}...".white
        if (Pathname.new("#{@@cache_dir}/#{name}").expand_path.exist?)
            Dir.chdir("#{@@cache_dir}/#{name}") do
                @vcs.update
            end
        else
            Dir.chdir(@@cache_dir) do
                @vcs.clone(self["repo"])
                @vcs.ignore_file_perms(name)
            end
        end
    end

    def get_deps
        puts "Installing dependencies...".white
        @pm.install([self["vcs"]].concat(self["deps"][@pm.pkgmgr]))
        @pm.install(self["deps"]["perl"], "perl")
        @pm.install(self["deps"]["python2"], "python2")
        @pm.install(self["deps"]["python3"], "python3")
    end
    private :get_deps

    def install
        if (!cached?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        link if (!installed?)
        compile

        puts "Installing #{name}...".white
        execute("install")
    end

    def installed?
        Pathname.new("#{@@install_dir}/#{name}").expand_path.exist?
    end

    def link
        if (!cached?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts "Linking #{name}...".white
        FileUtils.ln_sf(
            "#{@@cache_dir}/#{name}",
            "#{@@install_dir}/#{name}"
        )
    end

    def lock
        if (!installed?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts "Locking #{name}...".white
        FileUtils.touch("#{@@install_dir}/#{name}/.mspac_lock")
    end

    def name
        return self["name"]
    end

    def purge
        if (!cached?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts "Purging #{name}...".white
        FileUtils.rm_rf("#{@@cache_dir}/#{name}")
    end

    def remove(nosave = false)
        if (!installed?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts "Removing #{name}...".white
        execute("remove")
        unlink
        purge if (nosave)
    end

    def repo
        return self["repo"]
    end

    def unlink
        if (!installed?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts "Unlinking #{name}...".white
        FileUtils.rm_f("#{@@install_dir}/#{name}")
    end

    def unlock
        if (!installed?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts "Unlocking #{name}...".white
        FileUtils.rm_f("#{@@install_dir}/#{name}/.mspac_lock")
    end

    def update(force = false)
        if (!installed?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        Dir.chdir("#{@@install_dir}/#{name}") do
            if (Pathname.new(".mspac_lock").expand_path.exist?)
                puts "Locked: #{name}".red
                return
            end

            puts "Updating #{name}...".white
            tip = @vcs.revision
            @vcs.update
            new_tip = @vcs.revision

            if ((tip != new_tip) || force)
                install
            end
        end
    end
end
