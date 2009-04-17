module Tango
  module SaveWithoutCallbacks

    def self.included(base) #:nodoc:
      base.class_eval do
        attr_accessor :skip_callbacks
      end
    
      base.alias_method_chain :callback, :callbacks_check
    end
    
    # Check to see if the flag has been set, if so just return true, if not then run the callbacks as before
    
    def callback_with_callbacks_check(method)
      if skip_callbacks == true
        true
      else
        callback_without_callbacks_check(method)
      end
    end


  end
end
