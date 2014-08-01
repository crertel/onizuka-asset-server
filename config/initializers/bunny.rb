require "bunny"

config = YAML.load_file("#{Rails.root}/config/asset_config.yml")["bunny"]
bunny = Bunny.new(config[Rails.env])
bunny.start
channel = bunny.create_channel
q = channel.fanout("assets")
OnizukaAssetServer::Application.config.bunny = Struct.new(:exchange, :connection).new(q, bunny)
