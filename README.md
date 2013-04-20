heroku_keep_alive
=================

Keep heroku from spinning down your dynos.

Heroku automatically spins down single dyno apps if they aren't accessed frequently enough.  This script attempts
to get around that by pinging your sites at different intervals.

# Usage

You can run `ruby heroku_keep_alive.rb -h` to get usage information.

Basically, just create `config.yml` in the same directory (or specify `-c` to point to a different config)
as the script.  Format looks like:

```yml
mysite:
  url: 'http://mysite.herokuapp.com'
```

# Disclaimer

This is experimental, I'm still working on it, blah blah blah, don't get mad at me if it doesn't work/DOSes your site.
