library(rtoot)

# # create dummy token file
# token_raw <- readRDS("/home/jemma/.config/rstudio/R/rtoot/rtoot_token.rds")
# token_str <- token_raw$bearer
# token_dummy <- token_raw
# token_dummy$bearer <- "a secret"
# saveRDS(token_dummy, "rtoot_token_dummy.rds")

token <- readLines("token_bearer.secret")
token_dummy <- readRDS("rtoot_token_dummy.rds")

rtoot_token <- token_dummy
rtoot_token$bearer <- token

saveRDS(rtoot_token, file.path(tools::R_user_dir("rtoot", "config"), "rtoot_token.rds"))

# all.equal(token_raw, rtoot_token)
