$:.unshift(File.dirname(__FILE__) + '/../..')
$:.unshift(File.dirname(__FILE__) + '/../../lib')
schema_file = File.join(File.dirname(__FILE__), '..', 'schema.rb')
ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'test/unit'
require 'action_controller'
require 'action_controller/test_case'
require 'action_dispatch/testing/integration'
require 'active_record'
require 'active_record/fixtures'
require 'active_support/test_case'
require 'active_support/testing/autorun'

require 'rails'
require 'rails-controller-testing'

require 'userstamp'

Rails::Controller::Testing.install

config = YAML::load(IO.read(File.join(File.dirname(__FILE__), '..', 'database.yml')))[ENV['DB'] || 'test']
ActiveRecord::Base.configurations = config
ActiveRecord::Base.establish_connection(config)

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/models.log")
ActionController::Base.logger = Logger.new(File.dirname(__FILE__) + "/controllers.log")

load(schema_file) if File.exist?(schema_file)

Rails.logger = Logger.new(STDOUT)

class TestApplication < Rails::Application
end

TestApplication.initialize!

class ActiveSupport::TestCase #:nodoc:
  include ::ActiveRecord::TestFixtures

  self.fixture_path = File.join(File.dirname(__FILE__), '..', 'fixtures')

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Instantiated fixtures are slow, but give you @david where you otherwise would need people(:david)
  self.use_instantiated_fixtures  = true

  # Add more helper methods to be used by all tests here...
end
