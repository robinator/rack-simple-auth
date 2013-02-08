# Rack::SimpleAuth

A dead simple rack middleware for cookie authentication.  This middleware enhances an existing auth solution by providing access to multiple apps (which may have their own authentication code) from a single cookie. This was originally created to prevent access to a set of staging apps.  We use our own key/secret and cookie here so that the staging apps can maintain their own cookie secrets and authentication solutions.

### Usage

For rails, create an initializer file with something like:

    MyApp::Application.config.middleware.use Rack::SimpleAuth,
      key: 'your_cookie_key',
      secret: 'my_long_secret',
      login_url: 'http://url_where_user_will_be_redirected_to_authenticate.com'

### How it Works

The middleware relies on you creating a custom cookie with your own authentication code. Your authentication cookie code can decide which domain this cookie applies to, allowing you to create a universal access token for all apps on a particular subdomain.

Example cookie code:

    # called after a user has authenticated
    def save_auth_cookie
      packed_data = [my_cookie_data.to_s].pack('m*')
      hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, YOUR_SECRET, packed_data)
      cookies[YOUR_KEY] = { domain: '.yourdomain.com', value: "#{packed_data}--#{hmac}" }
    end

If cookie authentication fails in the middleware, it will redirect the user to the url provided in the `login_url` option. The middleware will also send the requested url in the return_to param so that you may redirect the user back to the requested url once they have authenticated.