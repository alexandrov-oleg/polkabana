#!/usr/bin/env ruby

require "getoptlong"

chromatic_scale = {
"flat" => %w(C Db D Eb E F Gb G Ab A Bb B), 
"sharp" => %w(C C# D D# E F F# G G# A A# B)
}

modes={
"major" => [2, 2, 1, 2, 2, 2, 1],
"dorian" => [2, 1, 2, 2, 2, 1, 2],
"natural minor" => [2, 1, 2, 2, 1, 2, 2]
}

opts = GetoptLong.new(
	[ "--help", "-h", GetoptLong::NO_ARGUMENT ],
	[ "--mode", "-m", GetoptLong::REQUIRED_ARGUMENT ],
	[ "--tonic", "-t", GetoptLong::REQUIRED_ARGUMENT ],
	[ "--intonation", "-i", GetoptLong::REQUIRED_ARGUMENT ]
)

mode_name = "major"
tonic = "C"
intonation = "flat"

opts.each do |opt, arg|
	case opt
		when "--mode"
		mode_name = arg.downcase
		when "--intonation"
		intonation = arg.downcase
		when "--tonic"
		tonic = arg.capitalize
		when '--help'
		puts <<-EOF

scale - lists notes of musical mode starting from the tonic

-h, --help
   show help

-m, --mode
   mode name, e.g. "natural minor"

-t, --tonic
   note to start with, e.g. "Bb"
   
-i, --intonation
   list notes with flat or sharp signs

Example

   scale -m "natural minor" -t F -i flat

EOF
		exit
	end
end

source_scale = chromatic_scale[intonation]

if source_scale.include? tonic
	note_index = source_scale.index(tonic)
else
	alt_intonation = ["flat", "sharp"] - [intonation]
	note_index = chromatic_scale[alt_intonation.first].index(tonic)
end

scale = modes[mode_name].collect do |d|
	note_index += d
	note_index -= 12 if note_index > 11
	source_scale[note_index]
end.unshift tonic

puts scale.join " "

