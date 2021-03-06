module Nunchaku
  class LatestQuotesWorker
    @queue = :latest_quotes_queue

    def self.perform
      Nunchaku::ExchangeRate.populate(Date.today)
    end
  end
end
