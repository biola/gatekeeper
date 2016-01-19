Gatekeeper
==========

Gatekeeper handles the creation and management of user accounts for friends of Biola University who do not have a regular Biola student or staff account.

Features
--------

- User account creation
- Email addresses must be confirmed via a link sent by email
- Forgot password via link sent by email
- Users can change passwords, edit or delete their accounts
- Return to original site after account creation
- User IP, user agent string and referring site are recorded on creation
- Admins can view users
- Admins can see a history of deleted users
- Admins can edit or delete user accounts
- Admins can search user and deleted user accounts
- Admins can associate a user account with a Biolan user account

### Link to returning to after account creation
If you want to have a Create Account link on your site that will return the user to your site after they've created their account. Just add a `return` query string parameter to your URL, like so: `http://gatekeeper.dev/create?return=http%3A%2F%2Fexample.com`.

Once their account has been created and confirmed, Gatekeeper will ask them to log into CAS with the service URL you provided in the `return` parameter.

Requirements
------------

- Ruby
- MongoDB
- Rack compatible web server
- CAS server (for admin logins)
- trogdir-api installation (for associating Biola people with accounts)

Installation
------------
```bash
git clone git@github.com:biola/gatekeeper.git
cd gatekeeper
bundle install
cp config/mongoid.yml.example config/mongoid.yml
cp config/settings.local.yml.example config/settings.local.yml
cp config/newrelic.yml.example config/newrelic.yml
```

Configuration
-------------

- Edit `config/mongoid.yml` accordingly
- Edit `config/settings.local.yml` accordingly
- Edit `config/newrelic.yml` accordingly

### External Authentication
If you'd like to have a third-party server (such as a CAS server) authenticate against the user collection, you should use a filter query like this.

`db.users.find({_type: 'NonBiolan', confirmed_at: {$ne: null}})`

Passwords are stored in the `password_digest` field using Rails' [`has_secure_password`](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password) which, in turn uses [bcrypt](https://en.wikipedia.org/wiki/Bcrypt)

Testing
-------

Simply run `rspec` to run the automated test suite.

Related Documentation
---------------------

- [turnout](https://github.com/biola/turnout)
- [pinglish](https://github.com/jbarnette/pinglish)
