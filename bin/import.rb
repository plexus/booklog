#!/usr/bin/env ruby

DATA.each_line do |file|
  contents = File.read(file.strip)
  title = contents[/title: (.*)$/, 1]
  image = contents[/image: (.*)$/, 1]
  date  = contents[/date: (.*)$/, 1]

  puts "mailx -v -A gmail -s \"#{title}\" -a ~/github/arnebrasseur.net/source/booklog/#{image} booklog@arnebrasseur.net <<< 'date: #{date}'"
end

__END__
/home/arne/github/arnebrasseur.net/source/booklog/2011-12-26-david-j-wallin-attachment-in-psychotherapy.md
/home/arne/github/arnebrasseur.net/source/booklog/2013-03-29-carpe-jugulum-terry-pratchett.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-06-08-starten-als-ondernemer-hans-crijns-luc-baltus.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-05-25-een-wereldtaal.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-06-08-a-confederacy-of-dunces-john-kennedy-toole.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-07-31-on-the-road-jack-kerouac.md
/home/arne/github/arnebrasseur.net/source/booklog/2013-01-08-the-beggar-king-and-the-secret-of-happiness-j.md
/home/arne/github/arnebrasseur.net/source/booklog/2013-01-08-the-relaxation-response-herbert-benson.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-02-22-hackers-and-painters-paul-graham.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-04-06-walden-henry-david-thoreau.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-08-25-foucaults-pendulum-umberto-eco.md
/home/arne/github/arnebrasseur.net/source/booklog/2013-01-08-the-color-of-magic-terry-pratchett.md
/home/arne/github/arnebrasseur.net/source/booklog/2013-02-28-the-enigma-of-capital-david-harvey.md
/home/arne/github/arnebrasseur.net/source/booklog/2013-02-27-logicomix-apostolos-doxiadis-christos-papadimitriou.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-12-07-eragon-christopher-paulini.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-07-31-chinese-lessons-john-pomfret.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-05-25-the-last-samurai.md
/home/arne/github/arnebrasseur.net/source/booklog/2012-10-25-maos-great-famine-frank-dikoetter.md
