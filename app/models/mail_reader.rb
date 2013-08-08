class MailReader
  class Config
    attr_accessor :username, :password, :server, :port, :ssl

    def initialize(username, password, server, port, ssl)
      @username, @password, @server, @port, @ssl = username, password, server, port, ssl
    end

    def self.from_env
      coercer = Coercible::Coercer.new
      new(
        ENV['POP3_USERNAME'],
        ENV['POP3_PASSWORD'],
        ENV.fetch('POP3_SERVER', 'pop.gmail.com'),
        ENV.fetch('POP3_PORT', 995), # defaults to 110
        ENV.has_key?('POP3_SSL') ?
          coercer[String].to_boolean(ENV['POP3_SSL']) :
          true
      )
    end

    def to_h
      Hash[
        [:username, :password, :server, :port, :ssl].map do |key|
          [key, self.send(key)]
        end
      ]
    end
  end

  def initialize(config)
    @config = config
    Mailman.config.pop3 = @config.to_h
    Mailman.config.poll_interval = 0 # do not poll, just run once
    @mailman = Mailman::Application.new
    @mailman.to config.username do
      Book.create_from_message!(message)
    end
  end

  def mailman_app
    @mailman
  end

  def run
    @mailman.run
  end

  def send_message(message)
    @mailman.router.route Mail.new(message)
  end
end


# begin
# rescue Net::OpenTimeout
#   $stderr.puts "Got timeout from Mailman, retrying"
#   retry
# end
