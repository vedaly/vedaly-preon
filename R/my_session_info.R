#!/usr/bin/env R

# Copyright © 2026 Vedaly Ltd <info@vedaly.io>
# Distributed under terms of the MIT license.

#' Get current session info like active project and sign-in status.
#'
#'
#' @return Invisibly returns TRUE if session exists
#' @export
my_session_info <- function() {

  session_file <- file.path(tools::R_user_dir("vedaly", "config"), "session.rds")
  if(file.exists(session_file)) {
    auth_config = readRDS(file.path(tools::R_user_dir("vedaly", "config"), "session.rds"))
    message(
      "Signed-in with email ",
      auth_config$email,
      " to organization ",
      auth_config$organization,
      ". Current active project: ",
      auth_config$active_project_name
    )
  } else {
    message("No session info is found. Please sign-in with vedaly::sign_in(email).")
  }

  return(invisible(TRUE))
}
