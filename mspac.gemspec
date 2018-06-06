Gem::Specification.new do |s|
    s.name = "mspac"
    s.version = "0.3.5"
    s.date = Time.new.strftime("%Y-%m-%d")
    s.summary = "Simple package manager for installing from source"
    s.description =
        "MsPac is a package manager written in ruby which tries to " \
        "mirror Arch's pacman. It's meant for installing " \
        "opensource tools from source. It only supports git or hg " \
        "repos at this time. I hope to add bzr and svn later. It " \
        "only supports apt-get and pacman for installing " \
        "dependencies at this time. I hope to add support for " \
        "brew, yum, and zipper later."
    s.authors = [ "Miles Whittaker" ]
    s.email = "mjwhitta@gmail.com"
    s.executables = Dir.chdir("bin") do
        Dir["*"]
    end
    s.files = Dir["lib/**/*.rb"]
    s.homepage = "https://gitlab.com/mjwhitta/mspac"
    s.license = "GPL-3.0"
    s.add_development_dependency("rake", "~> 12.3", ">= 12.3.1")
    s.add_runtime_dependency("hilighter", "~> 1.1", ">= 1.2.3")
    s.add_runtime_dependency("scoobydoo", "~> 0.1", ">= 0.1.6")
end
