utils::globalVariables(c(".data", "."))

#' @title find_string_distance
#'
#' @description Returns a list of dataframes arranged by most similiar strings.
#'
#' @param .s a character vector to be matched.
#' @param .t a character vector to be matchad against.
#' @param ignore_case should case be ignored? Default is TRUE.
#' @param ... other arguments passed to utils::adist.
#'
#' @examples
#'
#' find_string_distance("pple", stringr::fruit)
#'
#' @return a list of dataframes
#'
#' @export
find_string_distance <- function(.s, .t, ignore_case = TRUE, ...) {
  if(class(.s) != "character") stop("'.s' need to be character vector")
  if(class(.t) != "character") stop("'.t' need to be character vector")
  purrr::map(.s, function(.e) { 
    .d <- utils::adist(.t, .e, ignore.case = ignore_case)
    dplyr::tibble(input_string = .e,
           string = .t,
           string_distance = .d[, 1]) %>% 
      dplyr::arrange(.data$string_distance)
  }) %>% 
    purrr::set_names(.s)
}



#' @title find_most_similiar_string
#'
#' @description Returns a vector of most similiar string in another vector. 
#' Returns a vector of the same length as input vector '.s'.
#'
#' @param .s a character vector to be matched.
#' @param .t a character vector to be matchad against.
#' @param max_dist the maximum string distance
#' @param ignore_case should case be ignored? Default is TRUE.
#' @param verbose should warnings be printed in the console.
#' @param feeling_lucky if multiple most similiar strings are found. Should the first one be returned?
#' @param ... other arguments passed to utils::adist.
#'
#' @examples
#'
#' find_most_similiar_string(c("pple", "peacj"), stringr::fruit)
#'
#' @return a character vector
#'
#' @export
find_most_similiar_string <- function(.s, .t, max_dist = Inf, verbose = TRUE, ignore_case = TRUE, feeling_lucky = FALSE, ...) {
  if(class(.s) != "character") stop("'.s' need to be character vector")
  if(class(.t) != "character") stop("'.t' need to be character vector")
  
  .dfs <- find_string_distance(.s, .t, ignore_case = ignore_case)
  .dfs <- purrr::map(.dfs, function(.h) {.h %>% dplyr::filter(.data$string_distance <= max_dist)})
  
  out <- purrr::map_chr(.dfs, ~{
    .x <- .x %>% dplyr::filter(string_distance == min(string_distance))
    if(nrow(.x) > 1 & feeling_lucky) {
      if(verbose) warning(paste0("No single most similiar string found for '", 
                                 .x$input_string[1], 
                                 "'. Returning '", .x$string[1], "'. Other exactly similiar strings were ", 
                                 paste(paste0("'", .x$string[-1], "'"), 
                                       collapse = ", "), 
                                 "."))
      return(.x$string[1])
    }
    if(nrow(.x) > 1) {
      if(verbose) warning(paste0("No single most similiar string found for '", 
                                 .x$input_string[1], 
                                 "'. Returning NA. Most similiar strings were ", 
                                 paste(paste0("'", .x$string, "'"), 
                                       collapse = ", "), 
                                 "."))
      return(NA_character_)
    }
    if(nrow(.x) == 0) {
      if(verbose) warning(paste0("No similiar string below threshold found for '", .x$input_string[1], "'. Returning NA.\n"))
      return(NA_character_)
    }
    .x %>% dplyr::pull(string)
  })
  out %>% as.character()
}
