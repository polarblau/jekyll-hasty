require 'test_helper'

module Liquid
  class Tag
    def initialize(a, b, c)

    end
  end
  class Template
    class << self
      def register_tag(a, b)

      end
    end
  end
end

require 'jekyll/tags/hasty_comments'

class HastyCommentsTagTest < Test::Unit::TestCase

  VALID_GITHUB_REPO = "git@github.com:polarblau/jekyll-hasty-test-blog.git"

  def setup
    # TODO: mock?
    @tag = Jekyll::HastyCommentsTag.new('foo', 'bar', 'bat')
  end

  def test_file_name
    context = mock
    context.expects(:environments).
            returns([{'page' => {'file_name' => 'foo.md'}}])
    assert_equal @tag.file_name(context), 'foo.md'
  end

  def test_commit_ids
    @tag.expects(:`).
         with("git log --pretty=format:'%H' --follow foo.md").
         returns('123')
    assert_equal @tag.commit_ids('foo.md'), ['123']
  end

  def test_commit_ids_splitting
    @tag.expects(:`).returns("123\n456\n789")
    assert_equal @tag.commit_ids('foo.md'), ['123', '456', '789']
  end

  def test_commit_ids_empty
    @tag.expects(:`).returns("")
    assert_equal @tag.commit_ids('foo.md'), []
  end


  def test_repo_system_call
    @tag.expects(:`).
         returns(VALID_GITHUB_REPO).
         at_least_once
    @tag.repo
  end

  def test_repo_invalid_origin
    @tag.expects(:`).returns('foo')
    assert_raise RuntimeError do
      @tag.repo
    end
  end

  def test_repo_system_call_params
    @tag.expects(:`).
         with('git config --get remote.origin.url').
         returns(VALID_GITHUB_REPO).
         at_least_once
    assert_equal @tag.repo, 'polarblau/jekyll-hasty-test-blog'
  end


  def test_repo_return
    @tag.expects(:`).
         with('git config --get remote.origin.url').
         returns(VALID_GITHUB_REPO)
    @tag.repo
  end

  def test_github_commits_url
    @tag.expects(:repo).returns('the/repository')
    assert_equal @tag.github_commits_url,
      "#{Jekyll::HastyCommentsTag::API_REPOS_URL}the/repository/commits"
  end

  def test_generate_tag
    attr = {'foo' => 'bar'}
    assert_equal @tag.generate_tag(attr),
      "<div foo='bar'>bar</div>"
  end

end
