type CRED
    user::String
    pass::String
    personal::String
    secret::String
    token::String
end

CRED(user, pass, personal, secret) = CRED(user, pass, personal, secret, "")
CRED(user, personal, secret) = CRED(user, chomp(readline()), personal, secret, "")

type Subreddit
	name::String
	sorting::String
	ids::Vector{String}
    responses::Vector{Response}
    count::Int64
end