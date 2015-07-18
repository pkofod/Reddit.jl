function reddit_init(UserAgent::String)
    UserAgent
end

function reddit_cred(consumer_key::String, consumer_secret::String, oauth_token::String, oauth_secret::String)
    global cred

    return cred = CRED(consumer_key, consumer_secret, user, pass)

end

function reddit_revoke!(cred)
    enc = bytestring(encode(Base64, cred.user*":"*cred.pass))
    post(URI("https://www.reddit.com/api/v1/revoke_token"),
               "token=$(cred.token)&token_type_hint=access_token";
               headers = Dict("Authorization" => "Basic $enc",
               	              "User-Agent"    => "RedditAPI/0.1 by pkofod",
               	              "Content-Type"  => "application/x-www-form-urlencoded"))
end

function reddit_token!(cred)
    enc = bytestring(encode(Base64, cred.user*":"*cred.pass))
    respons = post(URI("https://www.reddit.com/api/v1/access_token"),
                   "grant_type=password&username=$(cred.user)&password=$(cred.pass)";
                   headers = Dict("Authorization" => "Basic $enc",
                                  "User-Agent"    => "RedditAPI/0.1 by pkofod",
                                  "Content-Type"  => "application/x-www-form-urlencoded"))

    cred.token = JSON.parse(respons.data)["access_token"]
end

function reddit_new(name, cred)
    new_sub = Subreddit(name,"new", String[],  Response[], 0)
    push!(new_sub.responses, get(URI("https://oauth.reddit.com/r/$name/new/.json");
                   headers = Dict("Authorization" => "bearer $(cred.token)",
                                  "User-Agent"    => "RedditAPI/0.1 by pkofod")))
    ids, new_sub.count = unique(new_sub)
    new_sub
end

function reddit_hot(name, cred)
    new_sub = Subreddit(name, "hot", String[], Response[], 0)
    push!(new_sub.responses, get(URI("https://oauth.reddit.com/r/$name/hot/.json");
                   headers = Dict("Authorization" => "bearer $(cred.token)",
                                  "User-Agent"    => "RedditAPI/0.1 by pkofod")))
    ids, new_sub.count = unique(new_sub)
    new_sub
end

function reddit_next!(sub, cred)
    push!(sub.responses, get(URI("https://oauth.reddit.com/r/$(sub.name)/$(sub.sorting)/.json?count=$(sub.count)&after=$(JSON.parse(sub.responses[end].data)["data"]["after"])");
                   headers = Dict("Authorization" => "bearer $(cred.token)",
                                  "User-Agent"    => "RedditAPI/0.1 by pkofod",
                                  "Content-Type"  => "application/x-www-form-urlencoded")))

    sub.ids, sub.count = unique(sub)
end

function reddit_all!(sub, cred)

    for i = 1:50
      if sub.count < length(sub.responses)
          return
      end

      sleep(2)
      reddit_next!(sub, cred)
    end
end

function unique(sub::Subreddit)
  ids = []
  for resp in sub.responses
      for child in JSON.parse(resp.data)["data"]["children"]
          push!(ids, child["data"]["name"])
      end
  end
  return ids, length(unique(ids))
end

function unique!(sub::Subreddit, ids, n_unique)
  for child in JSON.parse(sub.responses[end].data)["data"]["children"]
    push!(ids, child["data"]["name"])
  end
  n_unique = length(unique(ids))
end
