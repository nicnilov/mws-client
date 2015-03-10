require 'dotenv'
require 'highline/import'
require_relative 'mws_client'

module Cli
  def self.execute
    display_welcome
    merchant_id = ask('Seller ID: ') { |q| q.default = ENV['AMWS_MERCHANT_ID'] }
    marketplace_id = ask('Marketplace ID: ') { |q| q.default = ENV['AMWS_MARKETPLACE_ID'] }
    aws_access_key_id = ask('AWS Access Key ID: ') { |q| q.default = ENV['AMWS_ACCESS_KEY'] }
    aws_secret_access_key = ask('Secret Key: ') { |q| q.default = ENV['AMWS_ACCESS_SECRET'] }

    [merchant_id, marketplace_id, aws_access_key_id, aws_secret_access_key].each do |value|
      throw 'Every parameter should have a value' if value.to_s == ''
    end

    @mws_client = MwsClient.new({
      merchant_id: merchant_id,
      marketplace_id: marketplace_id,
      aws_access_key_id: aws_access_key_id,
      aws_secret_access_key: aws_secret_access_key
    })
    @mws_client.import_products
  end

  def self.display_welcome
    say("================================================================\n"\
        "           Import products to Amazon MWS trial script           \n"\
        "                                                                \n"\
        "              Please enter Amazon MWS credentials               \n"\
        '================================================================')
  end

end

begin
  Dotenv.load(File.expand_path('../../.env', __FILE__))
  Cli.execute
  say('Finished successfully')
rescue => error
  say("Exception: #{error.message}\n\n#{error.backtrace}")
end
