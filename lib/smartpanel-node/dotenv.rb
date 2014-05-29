require 'dotenv'

root_path = Pathname.new File.expand_path('../../..', __FILE__)

Dotenv.load root_path + '.env'
Dotenv.load *Dir.glob(root_path + "config/**/*.env")
