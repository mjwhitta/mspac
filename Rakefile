task :default => :gem

desc "Clean up"
task :clean do
    system("rm -f *.gem Gemfile.lock")
    system("chmod -R go-rwx bin lib")
end

desc "Build gem"
task :gem do
    system("chmod -R u=rwX,go=rX bin lib")
    system("gem build mspac.gemspec")
end

desc "Build and install gem"
task :install => :gem do
    system("gem install mspac*.gem")
end

desc "Push gem to rubygems.org"
task :push => [:clean, :gem] do
    system("gem push mspac*.gem")
end