# jekyll-hasty

"!https://secure.travis-ci.org/polarblau/jekyll-hasty.png!":http://travis-ci.org/polarblau/jekyll-hasty

## Preconditions

* git repository
* git remote at Github

## Installation

```bash
gem install jekyll-hasty
```

```ruby
# _plugins/ext.rb
require 'jekyll/hasty'
```

Add jquery plugin as described here:
https://github.com/polarblau/hasty

## Usage

In your posts use the hasty tag:

```markdown
{% hasty_comments %}
```

Ensure your posts are committed.

## WARNING!

This first version of jekyll-hasty [monkey–patches](https://github.com/polarblau/jekyll-hasty/blob/master/lib/jekyll/post.rb) `Jekyll::Post` by
overriding/extending `#to_liquid`. It is definitely a goal to solve this
otherwise in the future, either by forking Jekyll, suggesting the
extension to original project or some other way.
