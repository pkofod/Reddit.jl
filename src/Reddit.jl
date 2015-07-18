module Reddit

# Inspired by Twitter.jl

using Requests, DataFrames, Codecs, JSON

#import DataFrames: DataFrame
import Requests: get, post
import Requests: Response
import Base: unique
export reddit_token!, reddit_cred, reddit_init, reddit_new, reddit_hot, reddit_revoke!, reddit_next!, reddit_all!, Subreddit

include("./Types.jl")
include("./Utilities.jl")

end # module Reddit
