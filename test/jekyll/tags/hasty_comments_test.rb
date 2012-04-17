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

  def teardown
    @tag = nil
  end

  def test_current_file
    context = mock
    context.expects(:environments).
            returns([{'page' => {'file_name' => 'foo.md'}}])
    assert_equal @tag.current_file(context), 'foo.md'
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

  def test_github_user
    @tag.expects(:repo).returns('user/repository')
    assert_equal @tag.github_user, 'user'
  end

  def test_github_repo
    @tag.expects(:repo).returns('user/repository')
    assert_equal @tag.github_repo, 'repository'
  end

  def test_generate_tag
    @tag.expects(:commit_ids).returns(['123abc'])
    @tag.expects(:github_user).returns('user')
    @tag.expects(:github_repo).returns('repo')

    assert_equal @tag.generate_tag('file.md'),
      "<div id='comments' data-github-user='user' data-github-repo='repo' data-commit-ids='[\"123abc\"]'>bar</div>"
  end

  def test_attributes_id
    @tag.expects(:commit_ids).returns(['123'])

    attr = @tag.attributes('foo.md')
    assert attr.keys.include? 'id'
    assert_equal attr['id'], 'comments'
  end

  def test_attributes_github_user
    @tag.expects(:github_user).returns('user')
    @tag.expects(:commit_ids).returns(['123'])

    attr = @tag.attributes('foo.md')
    assert attr.keys.include? 'data-github-user'
    assert_equal attr['data-github-user'], 'user'
  end

  def test_attributes_github_repo
    @tag.expects(:github_repo).returns('repo')
    @tag.expects(:commit_ids).returns(['123'])

    attr = @tag.attributes('foo.md')
    assert attr.keys.include? 'data-github-repo'
    assert_equal attr['data-github-repo'], 'repo'
  end

  def test_attributes_commit_ids
    @tag.expects(:commit_ids).returns(['123'])

    attr = @tag.attributes('foo.md')
    assert attr.keys.include? 'data-commit-ids'
    assert_equal attr['data-commit-ids'], ['123']
  end

end
