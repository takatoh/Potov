require './app'

use Rack::ShowExceptions

run Potov::PotovApp.new
