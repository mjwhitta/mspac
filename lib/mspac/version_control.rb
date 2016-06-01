class MsPac::VersionControl
    def clone(repo)
        return if (repo.nil? || repo.empty?)

        case @vcs
        when "git", "hg"
            system("#{@vcs} clone #{repo}")
        when "powerpellet"
            # do nothing
        else
            raise MsPac::Error::UnsupportedVCS.new(@vcs)
        end
    end

    def ignore_file_perms(name)
        case @vcs
        when "git"
            Dir.chdir(name) do
                system("git config core.filemode false")
            end
        when "hg", "powerpellet"
            # do nothing
        else
            raise MsPac::Error::UnsupportedVCS.new(@vcs)
        end
    end

    def initialize(vcs)
        case vcs
        when "bzr"
            raise MsPac::Error::UnsupportedVCS.new(vcs)
        when "git", "hg", "powerpellet"
            @vcs = vcs
        when "svn"
            raise MsPac::Error::UnsupportedVCS.new(vcs)
        else
            raise MsPac::Error::UnsupportedVCS.new
        end
    end

    def revision
        case @vcs
        when "git"
            return %x(
                git log --oneline | head -n 1 | awk '{print $1}'
            )
        when "hg"
            return %(hg tip --template "{node}")
        when "powerpellet"
            return "powerpellet"
        else
            raise MsPac::Error::UnsupportedVCS.new(@vcs)
        end
    end

    def update
        case @vcs
        when "git"
            system("git reset && git pull")
        when "hg"
            system("hg pull && hg update")
        when "powerpellet"
            # do nothing
        else
            raise MsPac::Error::UnsupportedVCS.new(@vcs)
        end
    end
end
