require 'logger'

module MsdOdata
  module Util
    module Logging
      def log(msg)
        logger = Logger.new($stdout)
        logger.info(msg)
      end
    end
  end
end
