module Jekyll
  class HastyCommentsTag < Liquid::Tag

    API_REPOS_URL = 'https://api.github.com/repos'

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      file_name = context.environments.first["page"]["file_name"]
      puts "", "File name: #{file_name}", ""
      cmd = "git log --pretty=format:'%H' --follow #{file_name}"
      commit_ids = `#{cmd}`.split(/\W+/)#.split('\n')

      url = `git config --get remote.origin.url`.chomp
      url.gsub!(%r{git://github.com/(.*\.git)}, 'git@github.com:\1')

      if url =~ /^git@github/
        # validate that it's a proper github url
      else
        raise "only supports github URLs"
      end

      repo = url.scan(%r{git@github.com:(.*).git}).flatten.first

      comments_url = [API_REPOS_URL, repo, 'commits', '{sha}', 'comments'].join('/')

      attributes = {
        'id'                => 'comments',
        'data-comments-url' => comments_url,
        'data-commit-ids'   => commit_ids
      }

      markup = "<div "
      markup << attributes.map{|k, v| "#{k}='#{v}'"}.join(' ')
      markup << ">#{@text}</div>"

      markup
    end
  end

end

Liquid::Template.register_tag('hasty_comments', Jekyll::HastyCommentsTag)
