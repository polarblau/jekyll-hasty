require 'json'

class Hash
  # with Ruby 1.8.7 Array#to_s yields
  # '123' for [1,2,3], same for Hashes
  def to_html_attributes
    attr = []
    self.each do |k, v|
      if v.is_a?(Array) || v.is_a?(Hash)
        attr << "#{k}='#{v.to_json}'"
      else
        attr << "#{k}='#{v}'"
      end
    end
    attr.join(' ')
  end
end

module Jekyll
  class HastyCommentsTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      file = current_file(context)
      generate_tag(file)
    end

    # the "caller" file
    def current_file(context)
      context.environments.first["page"]["file_name"]
    end

    # gather all commit hashes affecting [file]
    def commit_ids(file)
      cmd = "git log --pretty=format:'%H' --follow #{file}"
      `#{cmd}`.split(/\W+/)
    end

    # get github repository information for current directoy
    def repo
      return @repo if defined?(@repo)
      url = `git config --get remote.origin.url`.chomp
      url.gsub!(%r{git://github.com/(.*\.git)}, 'git@github.com:\1')

      if url =~ /^git@github/
        @repo = url.scan(%r{git@github.com:(.*).git}).flatten.first
      else
        # TODO: proper exception
        raise "only supports github URLs"
      end
    end

    # extract github user
    def github_user
      repo.split('/').first
    end

    # extract github repository name
    def github_repo
      repo.split('/').last
    end

    # gather attributes for the tag
    def attributes(file)
      {
        'id'               => 'comments',
        'data-github-user' => github_user,
        'data-github-repo' => github_repo,
        'data-commit-ids'  => commit_ids(file)
      }
    end

    # generates <div/> tag and assigns [attributes]
    # as attributes to it
    def generate_tag(file)
      html_attributes = attributes(file).to_html_attributes
      "<div #{html_attributes}>#{@text}</div>"
    end

  end
end

Liquid::Template.register_tag('hasty_comments', Jekyll::HastyCommentsTag)


