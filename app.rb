# typed: false
# frozen_string_literal: true

Bundler.require
require_relative 'config'

opts = Slop.parse do |o|
  # ...
end

level = opts.arguments[0]&.to_i
step = opts.arguments[1]&.to_s&.downcase

unless level && step && LEVELS.include?(level) && STEPS.include?(step)
  puts "Invalid options: #{opts.arguments}"
  return
end

puts "Running Level #{level} Step #{step}"

require_relative "./#{level}_#{step}.rb"
Level.run(File.open("input/#{level}.txt").read)
