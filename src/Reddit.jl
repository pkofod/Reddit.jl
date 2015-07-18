module Reddit

# Inspired by Twitter.jl

using Requests, DataFrames, Codecs, JSON

#import DataFrames: DataFrame
import Requests: get, post
import Requests: Response
import Base: unique
export get_token!, cred, get_new, get_hot, get_gilded, get_controversial, get_top, get_rising, revoke!, get_next!, get_all!, Subreddit

include("./Types.jl")
include("./Utilities.jl")

end # module Reddit
