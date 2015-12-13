class MsPac::VersionControl
    def clone(repo)
        return if (repo.nil? || repo.empty?)

        case @vcs
        when "git", "hg"
            system("#{@vcs} clone #{repo}")
        else
            raise Error::UnsupportedVCSError.new(@vcs)
        end
    end

    def ignore_file_perms(name)
        Dir.chdir(name) do
            case @vcs
            when "git"
                system("git config core.filemode false")
            when "hg"
                # do nothing
            else
                raise Error::UnsupportedVCSError.new(@vcs)
            end
        end
    end

    def initialize(vcs)
        case vcs
        when "bzr"
            raise Error::UnsupportedVCSError.new(vcs)
        when "git"
            @vcs = vcs
        when "hg"
            @vcs = vcs
        when "svn"
            raise Error::UnsupportedVCSError.new(vcs)
        else
            raise Error::UnsupportedVCSError.new
        end
    end

    def revision
        case @vcs
        when "git"
            %x(git log --oneline | head -n 1 | awk '{print $1}')
        when "hg"
            %(hg tip --template "{node}")
        else
            raise Error::UnsupportedVCSError.new(@vcs)
        end
    end

    def update
        case @vcs
        when "git"
            system("git reset && git pull")
        when "hg"
            system("hg pull && hg update")
        else
            raise Error::UnsupportedVCSError.new(@vcs)
        end
    end
end
