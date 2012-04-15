# jekyll-hasty

[![Build Status](https://secure.travis-ci.org/polarblau/jekyll-hasty.png)](http://travis-ci.org/polarblau/jekyll-hasty])


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
