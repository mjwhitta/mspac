require "colorize"
require "fileutils"

class MsPac::Pellet < Hash
    @@cache_dir = Pathname("~/.mspac/cache").expand_path
    @@install_dir = Pathname("~/.mspac/installed").expand_path

    def colorize_cached(cached)
        if (!MsPac.colorize?)
            return "[cached]" if (cached)
        else
            return "[cached]".light_blue if (cached)
        end
        return ""
    end
    private :colorize_cached

    def colorize_error(error)
        return error if (!MsPac.colorize?)
        return error.light_red
    end
    private :colorize_error

    def colorize_installed(installed)
        if (!MsPac.colorize?)
            return "[installed]" if (installed)
        else
            return "[installed]".light_green if (installed)
        end
        return ""
    end
    private :colorize_installed

    def colorize_name(name = @name)
        return name if (!MsPac.colorize?)
        return name.light_white
    end
    private :colorize_name

    def colorize_status(status)
        return status if (!MsPac.colorize?)
        return status.light_white
    end
    private :colorize_status

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
        puts colorize_status("Compiling #{name}...")
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

        puts colorize_status("Fetching #{name}...")
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
        puts colorize_status("Installing dependencies...")
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

        puts colorize_status("Installing #{name}...")
        execute("install")
    end

    def installed?
        Pathname.new("#{@@install_dir}/#{name}").expand_path.exist?
    end

    def link
        if (!cached?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts colorize_status("Linking #{name}...")
        FileUtils.ln_sf(
            "#{@@cache_dir}/#{name}",
            "#{@@install_dir}/#{name}"
        )
    end

    def lock
        if (!installed?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts colorize_status("Locking #{name}...")
        FileUtils.touch("#{@@install_dir}/#{name}/.mspac_lock")
    end

    def name
        return self["name"]
    end

    def purge
        if (!cached?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts colorize_status("Purging #{name}...")
        FileUtils.rm_rf("#{@@cache_dir}/#{name}")
    end

    def remove(nosave = false)
        if (!installed?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts colorize_status("Removing #{name}...")
        execute("remove")
        unlink
        purge if (nosave)
    end

    def repo
        return self["repo"]
    end

    def to_s
        header = [
            colorize_name(name),
            colorize_installed(installed?) || colorize_cached(cached?)
        ].join(" ")
        return [
            header,
            "    #{repo}",
            "    #{desc}"
        ].join("\n")
    end

    def unlink
        if (!installed?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts colorize_status("Unlinking #{name}...")
        FileUtils.rm_f("#{@@install_dir}/#{name}")
    end

    def unlock
        if (!installed?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        puts colorize_status("Unlocking #{name}...")
        FileUtils.rm_f("#{@@install_dir}/#{name}/.mspac_lock")
    end

    def update(force = false)
        if (!installed?)
            raise MsPac::Error::PelletNotInstalledError.new(name)
        end

        Dir.chdir("#{@@install_dir}/#{name}") do
            if (Pathname.new(".mspac_lock").expand_path.exist?)
                puts colorize_error("Locked: #{name}")
                return
            end

            puts colorize_status("Updating #{name}...")
            tip = @vcs.revision
            @vcs.update
            new_tip = @vcs.revision

            if ((tip != new_tip) || force)
                install
            end
        end
    end
end
