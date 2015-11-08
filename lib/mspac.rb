require "fileutils"
require "json"
require "pathname"
require "scoobydoo"
require "string"

class MsPac
    def cached
        return @pellets.keys.sort.delete_if do |name|
            !@pellets[name].cached?
        end
    end

    def clean
        @pellets.each do |name, pellet|
            pellet.purge if (pellet.cached? && !pellet.installed?)
        end
        # FIXME will miss pellets that get deleted by refresh
    end

    def ensure_pellets_repo
        @pellets_dir = Pathname.new("~/.mspac/pellets").expand_path
        return if (@pellets_dir && @pellets_dir.exist?)

        puts "Installing MsPac dependencies...".white
        @pm.install(["git"]) if (ScoobyDoo.where_are_you("git").nil?)
        Dir.chdir(@mspac_dir) do
            @vcs.clone("https://gitlab.com/mjwhitta/pellets.git")
        end

        @pellets_dir = Pathname.new("~/.mspac/pellets").expand_path
        if (@pellets_dir.nil? || !@pellets_dir.exist?)
            raise Error::PelletRepoError.new
        end
    end
    private :ensure_pellets_repo

    def initialize
        FileUtils.mkdir_p(Pathname.new("~/.mspac").expand_path)
        @mspac_dir = Pathname.new("~/.mspac").expand_path
        @pm = PackageManager.new
        @vcs = VersionControl.new("git")
        load_pellets
    end

    def install(pellets, force = false)
        if (pellets.nil? || pellets.empty?)
            raise Error::MissingPelletError.new
        end

        pellets.each do |name|
            if (@pellets.has_key?(name))
                pellet = @pellets[name]
                if (pellet.installed?)
                    pellet.update(force)
                elsif (pellet.cached?)
                    pellet.link
                    pellet.update(true)
                else
                    pellet.fetch
                    pellet.install
                end
            else
                raise Error::MissingPelletError.new(name)
            end
        end
    end

    def installed
        return @pellets.keys.sort.delete_if do |name|
            !@pellets[name].installed?
        end
    end

    def load_pellets
        ensure_pellets_repo

        @pellets = Hash.new
        Dir["#{@pellets_dir}/*.pellet"].each do |pellet|
            begin
                p = Pellet.new(JSON.parse(File.read(pellet)))
                @pellets[p.name] = p
            rescue JSON::ParserError => e
                puts "#{pellet} is not valid JSON!".red
                puts e.message.red
            rescue Exception => e
                puts e.message.red
            end
        end
    end
    private :load_pellets

    def lock(pellets)
        if (pellets.nil? || pellets.empty?)
            raise Error::MissingPelletError.new
        end

        pellets.each do |name|
            if (@pellets.has_key?(name))
                @pellets[name].lock
            else
                raise Error::MissingPelletError.new(name)
            end
        end
    end

    def pellets
        return @pellets.keys.sort
    end

    def refresh
        puts "Refreshing pellets...".white
        Dir.chdir(@pellets_dir) do
            @vcs.update
        end
    end

    def remove(pellets, nosave)
        if (pellets.nil? || pellets.empty?)
            raise Error::MissingPelletError.new
        end

        pellets.each do |name|
            if (@pellets.has_key?(name))
                @pellets[name].remove(nosave)
            else
                raise Error::MissingPelletError.new(name)
            end
        end
    end

    def search(regex)
        @pellets.keys.sort.each do |name|
            pellet = @pellets[name]
            name_match = pellet.name.match(/#{regex}/)
            desc_match = pellet.desc.match(/#{regex}/)
            if (name_match || desc_match)
                print "#{pellet.name}".white
                if (pellet.installed?)
                    puts " [installed]".green
                elsif (pellet.cached?)
                    puts " [cached]".blue
                else
                    puts
                end
                puts "    #{pellet.repo}"
                puts "    #{pellet.desc}"
            end
        end
    end

    def unlock(pellets)
        if (pellets.nil? || pellets.empty?)
            raise Error::MissingPelletError.new
        end

        pellets.each do |name|
            if (@pellets.has_key?(name))
                @pellets[name].unlock
            else
                raise Error::MissingPelletError.new(name)
            end
        end
    end

    def upgrade
        @pellets.keys.sort.each do |name|
            pellet = @pellets[name]
            pellet.update if (pellet.installed?)
        end
    end
end

require "mspac/error"
require "mspac/package_manager"
require "mspac/pellet"
require "mspac/version_control"
