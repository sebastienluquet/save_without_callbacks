require 'save_without_callbacks'
ActiveRecord::Base.send(:include, Tango::SaveWithoutCallbacks)