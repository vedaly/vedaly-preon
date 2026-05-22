#!/usr/bin/env R

# Copyright © 2026 Vedaly Ltd <info@vedaly.io>
# Distributed under terms of the MIT license.

#' Send GraphQL query/mutation to Hasura
#'
#' @param query_str query as a string
#' @param variables list of variables
#'
#' @return response as a list
#' @noRd

gql_send_query <- function(query_str, variables){

  gql_api_url <- getOption(
    "vedaly.gql_api_url",
    default = "https://graphql-prod.omicschart.com/v1/graphql"
  )

  auth_config = readRDS(file.path(tools::R_user_dir("vedaly", "config"), "session.rds"))

  # Send GraphQL request
  response <- httr::POST(
    url = gql_api_url,
    encode = "json",
    body = list( query = query_str, variables = variables ),
    httr::add_headers(
      Authorization = paste("Bearer", auth_config$id_token),
      `Content-Type` = "application/json"
    )
  )


  if (httr::http_error(response)) {
    stop("HTTP error during GraphQL query: ", httr::content(response, "text", encoding = "UTF-8"))
  }

  gql_results_content <- httr::content(response, as = "parsed", encoding = "UTF-8")

  if (!is.null(gql_results_content$errors)) {
    stop("GraphQL error: ", gql_results_content$errors[[1]]$message)
  }

  query_result = switch (names(result$data),
    "preon_op" = gql_results_content$data$preon_op,
    "preon_sci" = gql_results_content$data$preon_sci
  )

  return(query_result)
}
