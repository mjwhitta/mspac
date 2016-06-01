class MsPac::Error < RuntimeError
end

require "mspac/error/missing_pellet"
require "mspac/error/pellet_not_installed"
require "mspac/error/pellet_repo"
require "mspac/error/unsupported_package_manager"
require "mspac/error/unsupported_vcs"
