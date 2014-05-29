require 'dotenv'
Dotenv.load '.env'
Dotenv.load *Dir.glob("config/**/*.env")
