require 'rubygems'
require 'test/unit'
require 'sequel'

DB = Sequel.connect('sqlite:/')

class Author < Sequel::Model
  set_schema do
    primary_key :id
  end
  create_table!
  one_to_many :posts
end

class Post < Sequel::Model
  set_schema do
    primary_key :id
    foreign_key :author_id, :authors
  end
  create_table!
  many_to_one :author
  one_to_many :comments
  is :cascading, :destroy => :comments
end

class Comment < Sequel::Model
  set_schema do
    primary_key :id
    foreign_key :post_id, :posts
  end
  create_table!
  many_to_one :post
end

class SequelCascadingTest < Test::Unit::TestCase
  def test_should_leave_orphans_when_destroyed
    author = Author.create
    post = author.add_post(Post.new)
    author.destroy
    assert !author.exists?
    assert post.exists?
  end

  def test_should_destroy_children_when_destroyed
    post = Post.create
    comment = post.add_comment(Comment.new)
    post.destroy
    assert !post.exists?
    assert !comment.exists?
  end
end
