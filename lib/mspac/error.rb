class MsPac::Error < RuntimeError
end

require "mspac/error/invalid_operation_error"
require "mspac/error/missing_pellet_error"
require "mspac/error/multiple_operations_error"
require "mspac/error/pellet_not_installed_error"
require "mspac/error/pellet_repo_error"
require "mspac/error/unsupported_package_manager_error"
require "mspac/error/unsupported_vcs_error"
