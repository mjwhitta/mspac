Gem::Specification.new do |s|
    s.add_development_dependency("rake", "~> 13.0", ">= 13.0.0")
    s.add_runtime_dependency("hilighter", "~> 1.5", ">= 1.5.1")
    s.add_runtime_dependency("scoobydoo", "~> 1.0", ">= 1.0.1")
    s.authors = ["Miles Whittaker"]
    s.date = Time.new.strftime("%Y-%m-%d")
    s.description = [
        "MsPac is a package manager written in ruby which tries to",
        "mirror Arch's pacman. It's meant for installing open-source",
        "tools from source. It only supports git or hg repos at this",
        "time. I hope to add bzr and svn later. It only supports",
        "apt-get and pacman for installing dependencies at this",
        "time. I hope to add support for brew, yum, and zypper later."
    ].join(" ")
    s.email = "mj@whitta.dev"
    s.executables = Dir.chdir("bin") do
        Dir["*"]
    end
    s.files = Dir["lib/**/*.rb"]
    s.homepage = "https://gitlab.com/mjwhitta/mspac"
    s.license = "GPL-3.0"
    s.metadata = {"source_code_uri" => s.homepage}
    s.name = "mspac"
    s.summary = "Simple package manager for installing from source"
    s.version = "0.3.8"
end
