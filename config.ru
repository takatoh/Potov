require './app'

use Rack::ShowExceptions

run Potov::App.new
