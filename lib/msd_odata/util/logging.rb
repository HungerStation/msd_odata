require 'logger'

module MsdOdata
  module Util
    module Logging
      def log(msg)
        logger = Logger.new('logfile.log')
        logger.info(msg)
      end
    end
  end
end
