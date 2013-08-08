#!/usr/bin/env ruby

Dir['/home/arne/github/arnebrasseur.net/source/booklog/*.md'].each do |file|
  contents = File.read(file)
  title = contents[/title: (.*)$/, 1]
  image = contents[/image: (.*)$/, 1]

  puts "mailx -v -A gmail -s \"#{title}\" -a ~/github/arnebrasseur.net/source/booklog/#{image} booklog@arnebrasseur.net <<< ''"
end
