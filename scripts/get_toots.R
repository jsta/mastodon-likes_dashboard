# ---- setup ----
library(rtoot)
# auth_setup("mas.to", "user")
# token <- readRDS(file.path(tools::R_user_dir("rtoot", "config"), "rtoot_token.rds"))
# content <- convert_token_to_envvar(token)

if (!is.null(grep("comp", Sys.info()["nodename"]))) { # not on jsta local system
  # auth_setup(clipboard = TRUE)
  verify_envvar()
} else {
  # auth_setup_default()
}

read_latest <- function() {
  archives <- list.files("data", pattern = "*likes.rds",
    full.names = TRUE, include.dirs = TRUE)
  dates <- sapply(archives,
    function(x) strsplit(x, "_")[[1]][1])
  dates <- as.Date(
    sapply(dates, function(x) substring(x, nchar(x) - 9, nchar(x))))

  dt <- readRDS(archives[which.max(dates)])
  dt <- data.frame(dt)

  # dt <- dplyr::mutate(dt, status_id = dplyr::coalesce(status_id, as.character(id)))
  dt
}

# ---- get tweets ----
outfile <- file.path("data", paste0(Sys.Date(), "_jsta_likes.rds"))
print(outfile)
if (!file.exists(outfile)) {
  # auth_setup()
  jsta_likes <- rtoot::get_account_favourites()
  jsta_likes <- jsta_likes[
    order(jsta_likes$created_at, decreasing = TRUE), ]

  dt <- read_latest()
  i_archive_start <- ifelse( # in case i == 1 has been deleted (#6)
    length(which(jsta_likes$id == dt[1, "id"])) == 0,
    which(jsta_likes$id == dt[2, "id"]),
    which(jsta_likes$id == dt[1, "id"]))
  dt2 <- jsta_likes[1:i_archive_start, ]

  # dt2 <- dplyr::select(dt2, -media_url, -mentions_screen_name,
  #   -mentions_user_id,
  #   -hashtags)

  res <- dplyr::bind_rows(dt2, dt)

  saveRDS(res, outfile)
}
