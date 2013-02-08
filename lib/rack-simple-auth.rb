%w[ rubygems rack rack/request openssl ].each { |s| require s }

module Rack
  class SimpleAuth
    def initialize(app, options = {})
      @app = app
      @key = options[:key]
      @secret = options[:secret]
      @login_url = options[:login_url]
      @authenticated_with = options[:authenticated_with] || Proc.new { |value| true }
    end

    def call(env)
      request = Request.new(env)
      if authenticated? request.cookies
        @app.call(env)
      else
        [302, {'Content-Type' => 'text/plain', 'Location' => "#{@login_url}?return_to=#{request.url}"}, ['You must be logged in to see this.']]
      end
    end

    def authenticated?(cookies)
      if data = cookies[@key]
        packed_data, digest = data.split('--')
        hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, @secret, packed_data)
        begin
          # false if tampering going on
          digest == hmac && @authenticated_with.call(packed_data.unpack("m*").first)
        rescue
          false
        end
      else
        false
      end
    end
  end
end