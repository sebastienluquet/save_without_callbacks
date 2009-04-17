require 'test/unit'

ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

require 'rubygems'
require 'active_record'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

class Article < ActiveRecord::Base
  validates_presence_of :subject
  attr_accessible :subject
  
  before_save :tweak_body
  
  def tweak_body
    self.body = "I've been tweaked"
  end

end

class ArticleTest < Test::Unit::TestCase

  def setup
    ActiveRecord::Schema.define(:version => 1) do
      create_table :articles do |t|
        t.string :subject
        t.string :body
        t.timestamps
      end
    end
    quick_art = Article.new({:subject => "I like turtles", :body => "They are my favorite"})
    quick_art.skip_callbacks = true
    quick_art.save
  end
  
  def teardown
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end
	 
	def test_has_skip_callbacks
	  assert Article.new.skip_callbacks.nil?
	end

	def test_create_without_callbacks
    assert_difference('Article.count', 1) do
  	  article = Article.new
  	  article.skip_callbacks = true
  	  article.subject = "This is a test"
  	  assert article.save
  	  assert article.body.nil?
    end
	end

	def test_create_with_callbacks
    assert_difference('Article.count', 1) do	  
  	  article = Article.new
  	  article.subject = "This is a test"
  	  assert article.save
  	  assert_equal article.body, "I've been tweaked"
    end
	end

	def test_create_invalid_without_callbacks
    assert_difference('Article.count', 0) do
  	  article = Article.new
  	  article.skip_callbacks = true
  	  assert !article.save
  	  assert article.body.nil?
    end
	end

  def test_create_invalid_with_callback
    assert_difference('Article.count', 0) do
  	  article = Article.new
  	  assert !article.save
  	  assert article.body.nil?
    end
  end

	def test_update_without_callbacks
  	  article = Article.find(:first)
  	  article.skip_callbacks = true
  	  article.subject = "This is a test"
  	  assert article.save
  	  assert_equal article.body, "They are my favorite"
	end

	def test_update_with_callbacks
      article = Article.find(:first)
  	  article.subject = "This is a test"
  	  assert article.save
  	  assert_equal article.body, "I've been tweaked"
	end

	def test_update_invalid_without_callbacks
      article = Article.find(:first)
  	  article.skip_callbacks = true
  	  article.subject = nil
  	  assert !article.save
  	  assert_equal article.body, "They are my favorite"
	end

  def test_update_invalid_with_callback
      article = Article.find(:first)
  	  article.subject = nil      
  	  assert !article.save
  	  assert_equal article.body, "They are my favorite"
  end
  
end