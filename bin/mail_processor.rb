#!/usr/bin/env ruby

require 'mailman'
require_relative '../config/environment'

coercer = Coercible::Coercer.new

Mailman.config.pop3 = {
  :username => ENV['POP3_USERNAME'],
  :password => ENV['POP3_PASSWORD'],
  :server   => ENV.fetch('POP3_SERVER', 'pop.gmail.com'),
  :port     => ENV.fetch('POP3_PORT', 995), # defaults to 110
  :ssl      => ENV.has_key?('POP3_SSL') ? coercer[String].to_boolean(ENV['POP3_SSL']) : true
}

Mailman.config.poll_interval = 0 # do not poll, just run once

begin
  Mailman::Application.run do
    to ENV['POP3_USERNAME'] do
      Book.create_from_message!(message)
    end
  end
rescue Net::OpenTimeout
  $stderr.puts "Got timeout from Mailman, retrying"
  retry
end
