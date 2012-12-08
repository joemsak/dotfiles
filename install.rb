#!/usr/bin/env ruby

# from http://errtheblog.com/posts/89-huba-huba

def home
  File.expand_path('~')
end

def create_symlink(file)
  target = File.join(home, ".#{file}")
  `ln -is #{File.expand_path file} #{target}`
end

Dir['*'].each do |file|
  next if file =~ /install/
  create_symlink(file)
end

# git push on commit
`echo 'git push' > .git/hooks/post-commit`
`chmod 755 .git/hooks/post-commit`
