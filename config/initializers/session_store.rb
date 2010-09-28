# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_testirovanie_session',
  :secret      => '054e704b710aa37ece17b4ff22569809f44e9ccc32ccd784dd4318512b7eb08e6e95cd574c45fe578caa616ac0eb4daa4645430eb882546ae5373649bc3398d5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
