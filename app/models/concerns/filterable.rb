module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = where(nil)
      filtering_params.each do |scope, *args|  
        results = results.public_send("by_#{scope}", *args.compact)
      end
      results
    end
  end
end
