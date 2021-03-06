function cred(user::String, pass::String, personal::String, secret::String)
    return cred = CRED(user, pass, personal, secret)
end

function cred(user::String, personal::String, secret::String)
    return cred = CRED(user, personal, secret)
end

# Should remove the stuff above

function revoke!(cred::CRED)
    enc = bytestring(encode(Base64, cred.personal*":"*cred.secret))
    post(URI("https://www.reddit.com/api/v1/revoke_token"),
               "token=$(cred.token)&token_type_hint=access_token";
               headers = Dict("Authorization" => "Basic $enc",
               	              "User-Agent"    => "RedditAPI/0.1 by pkofod",
               	              "Content-Type"  => "application/x-www-form-urlencoded"))
end

function token!(cred)
    enc = bytestring(encode(Base64, cred.personal*":"*cred.secret))
    respons = post(URI("https://www.reddit.com/api/v1/access_token"),
                   "grant_type=password&username=$(cred.user)&password=$(cred.pass)";
                   headers = Dict("Authorization" => "Basic $enc",
                                  "User-Agent"    => "RedditAPI/0.1 by pkofod",
                                  "Content-Type"  => "application/x-www-form-urlencoded"))

    cred.token = JSON.parse(respons.data)["access_token"]
end

macro sorting(sort)
    quote
        function $(esc(sort))(name, cred)
            sub = Subreddit(name, $(string(sort)), String[], Response[], 0)
            push!(sub.responses, get(URI(string("https://oauth.reddit.com/r/$name/", $(string(sort)), "/.json"));
                           headers = Dict("Authorization" => "bearer $(cred.token)",
                                          "User-Agent"    => "RedditAPI/0.1 by pkofod")))
            ids, sub.count = unique(sub)
            sub
        end
    end
end

@sorting new
@sorting hot
@sorting rising
@sorting controversial
@sorting top
@sorting gilded

function next!(sub, cred)
    push!(sub.responses, get(URI("https://oauth.reddit.com/r/$(sub.name)/$(sub.sorting)/.json?count=$(sub.count)&after=$(JSON.parse(sub.responses[end].data)["data"]["after"])");
                   headers = Dict("Authorization" => "bearer $(cred.token)",
                                  "User-Agent"    => "RedditAPI/0.1 by pkofod",
                                  "Content-Type"  => "application/x-www-form-urlencoded")))

    sub.ids, sub.count = unique(sub)
end

function get_all!(sub, cred::CRED)

    for i = 1:50
      if sub.count < length(sub.responses)
          return
      end

      sleep(2)
      next!(sub, cred)
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