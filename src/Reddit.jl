module Reddit

# Inspired by Twitter.jl

using Requests, DataFrames, Codecs, JSON

#import DataFrames: DataFrame
import Requests: get, post
import Requests: Response
import Base: unique
export token!, cred, new, hot, gilded, controversial,
	   top, rising, revoke!, next!, get_all!, Subreddit,
	   @sorting

include("./Types.jl")
include("./Utilities.jl")

end # module Reddit
