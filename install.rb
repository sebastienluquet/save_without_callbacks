# Install hook code here
ActiveRecord::Base.send(:include, SaveWithoutCallbacks)