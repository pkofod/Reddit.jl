# Reddit

[![Build Status](https://travis-ci.org/pkofod/Reddit.jl.svg?branch=master)](https://travis-ci.org/pkofod/Reddit.jl)

This is a very simple package for interacting with the Reddit API. Currently only "script" type apps are supported. Future versions might (hopefully) support the `code` flow. I suspect a package as http server as HttpServer.jl would be sufficient to automate this process.

# An example

You might want to turn off the history functionaly, or at least clean it up after doing the following. Your password is going to be in your history if you don't. I'll have to fix this in the future. The following example (with fake username and password, and missing private and secret keys) gets all new posts in /r/UpliftingNews.

```julia
using Reddit
using JSON
using Requests
UserAgent = "MyScraper/v0.1 by julia"
personal = "[private app key]"
secret = "[secret app key]"
my_cred=cred("julia", "juliaPass", personal, secret)
token!(my_cred)

uplifting_new=new("UpliftingNews",my_cred)

get_all!(uplifting_new, my_cred)

revoke!(my_cred)
```
