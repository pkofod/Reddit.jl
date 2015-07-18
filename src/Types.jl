type CRED
    user::String
    pass::String
    consumer_key::String
    consumer_secret::String
    token::String
end

CRED(key, secret, user, pass) = CRED(key, secret, user, pass, "")

type Subreddit
	name::String
	sorting::String
	ids::Vector{String}
    responses::Vector{Response}
    count::Int64
end