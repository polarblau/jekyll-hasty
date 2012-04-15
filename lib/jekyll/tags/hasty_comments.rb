module Jekyll
  class HastyCommentsTag < Liquid::Tag

    API_REPOS_URL = 'https://api.github.com/repos/'

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      file = file_name(context)

      attributes = {
        'id'               => 'comments',
        'data-commits-url' => github_commits_url,
        'data-commit-ids'  => commit_ids(file)
      }
      generate_tag(attributes)
    end

    #

    def file_name(context)
      context.environments.first["page"]["file_name"]
    end

    def commit_ids(file)
      cmd = "git log --pretty=format:'%H' --follow #{file}"
      `#{cmd}`.split(/\W+/)
    end

    def repo
      url = `git config --get remote.origin.url`.chomp
      url.gsub!(%r{git://github.com/(.*\.git)}, 'git@github.com:\1')

      if url =~ /^git@github/
        url.scan(%r{git@github.com:(.*).git}).flatten.first
      else
        # TODO: proper exception
        raise "only supports github URLs"
      end
    end

    def github_commits_url
      File.join(API_REPOS_URL, repo, 'commits')
    end

    def generate_tag(attributes)
      attr = attributes.map{|k, v| "#{k}='#{v}'"}.join(' ')
      "<div #{attr}>#{@text}</div>"
    end

  end
end

Liquid::Template.register_tag('hasty_comments', Jekyll::HastyCommentsTag)
