#!/usr/bin/env ruby

require_relative '../config/environment.rb'

BASEDIR = '/home/arne/github/arnebrasseur.net/source/booklog/'
Dir["#{BASEDIR}/*.md"].each do |file|
  contents = File.read(file)
  title = contents[/title: (.*)$/, 1]
  image = contents[/image: (.*)$/, 1]
  date  = contents[/date: (.*)$/, 1]
  Book.create! title: title, image: File.open("#{BASEDIR}/#{image}"), finish_date: DateTime.parse(date)
end
