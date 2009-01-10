module Sequel
  module Plugins
    module Cascading
      def self.apply(model, options = {})
        Array(options[:destroy]).each do |assoc|
          model.instance_eval "before_destroy { #{assoc}_dataset.destroy }"
        end
      end
    end
  end
end
