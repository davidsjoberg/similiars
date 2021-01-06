utils::globalVariables(c(".data", "."))

#' @title find_string_distance
#'
#' @description Returns a list of dataframes arranged by most similar strings.
#'
#' @param .s a character vector to be matched.
#' @param .t a character vector to be matchad against.
#' @param ignore_case should case be ignored? Default is TRUE.
#' @param ... other arguments passed to utils::adist.
#'
#' @details Uses the generalized Levenshtein distance. For more information type \code{?utils::adist} in the console.
#'
#' @examples
#'
#' find_string_distance("battman", superheroes)
#'
#' @return a list of dataframes
#'
#' @export
find_string_distance <- function(.s, .t, ignore_case = TRUE, ...) {
  if(any(!is.character(.t), !is.character(.s))) stop("'.s' and '.t' need to be character vectors")
 
  purrr::map(.s, function(.e) { 
    .d <- utils::adist(.t, .e, ignore.case = ignore_case)
    dplyr::tibble(input_string = .e,
           string = .t,
           string_distance = .d[, 1]) %>% 
      dplyr::arrange(.data$string_distance)
  }) %>% 
    purrr::set_names(.s)
}



#' @title find_most_similar_string
#'
#' @description Returns a vector of most similar string in another vector. 
#' Returns a vector of the same length as input vector '.s'.
#'
#' @param .s a character vector to be matched.
#' @param .t a character vector to be matched against.
#' @param max_dist the maximum string distance
#' @param ignore_case should case be ignored? Default is TRUE.
#' @param verbose should warnings be printed in the console.
#' @param feeling_lucky if multiple most similar strings are found. Should the first one be returned?
#' @param ... other arguments passed to utils::adist.
#' 
#' @details Uses the generalized Levenshtein distance. For more information type \code{?utils::adist} in the console.
#'
#' @examples
#'
#' find_most_similar_string(c("battman", "Irn Man"), superheroes)
#'
#' @return a character vector
#'
#' @export
find_most_similar_string <- function(.s, .t, max_dist = Inf, verbose = TRUE, ignore_case = TRUE, feeling_lucky = FALSE, ...) {
  if(any(!is.character(.t), !is.character(.s))) stop("'.s' and '.t' need to be character vectors")
  .dfs <- find_string_distance(.s, .t, ignore_case = ignore_case)
  .dfs <- purrr::map(.dfs, function(.h) {.h %>% dplyr::filter(.data$string_distance <= max_dist)})
  
  out <- purrr::map_chr(.dfs, ~{
    if(is.na(.x$input_string[1])) {return(NA_character_)}
    .x <- .x %>% dplyr::filter(string_distance == min(string_distance))
    
       if( nrow(.x) > 1){
       if(feeling_lucky){
         
         if(verbose){
          warning(paste0("No single most similar string found for '", 
                         .x$input_string[1], 
                         "'. Returning '", .x$string[1], "'. Other exactly similar strings were ", 
                         paste(paste0("'", .x$string[-1], "'"), 
                               collapse = ", "), 
                         "."))
         }
          return(.x$string[1])
          
       } else{
         if(verbose){
           
           warning(paste0("No single most similar string found for '", 
                          .x$input_string[1], 
                          "'. Returning NA. Most similar strings were ", 
                          paste(paste0("'", .x$string, "'"), 
                                collapse = ", "), 
                          "."))
         }
         return(NA_character_)  
        }
      }
      if( nrow(.x) == 0 ){
        if(verbose){
          warning(paste0("No similar string below threshold found for '", .x$input_string[1], "'. Returning NA.\n"))
        }
        return(NA_character_)
      }
    .x %>% dplyr::pull(string)
  })
  out %>% as.character()
}


#' @title case_when_skeleton
#'
#' @description Returns a \code{case_when} from \code{dplyr} to replace .s with .r. You can copy the output and put in the script to avoid manual work.
#'
#' @param .s a character vector to be replaced.
#' @param .r a character vector to replace with.
#' @param var_name Optional. the name of the variable that should be replaced. If NULL or not changed the call of '.s' is used.
#'
#' @examples
#'
#' case_when_skeleton(letters[1:10],
#'                    LETTERS[1:10],
#'                    var_name = "my_letters")
#'
#' @return console output with a case_when skeleton
#'
#' @export
case_when_skeleton <- function(.s, .r, var_name = NULL) {
  if(is.null(var_name)){
    .v <- rlang::enquo(.s)
    .v <- rlang::as_name(.v)
  } else {
    .v <- var_name
  }
  if(any(!is.character(.s), !is.character(.r), !is.character(.v))) stop("'.s', '.r' and 'var_name' need to be character vectors")
  if(length(.v) != 1) stop("'var_name' need to be a single character element")
  if(length(.s) != length(.r)) stop("'.s' and '.r' need to have the same length")
  .sims <- dplyr::tibble(input_string = .s,
                         most_similiar = .r,
                         var = .v) %>% 
    dplyr::distinct() %>% 
    tidyr::drop_na() %>% 
    dplyr::filter(.data$input_string != .data$most_similiar)
  
  replacement_lines <- purrr::pmap_chr(.sims, ~{
    stringr::str_glue("{..3} == \"{..1}\" ~ \"{..2}\",")
  }) %>% 
    paste0("    ", .) %>% 
    paste0(collapse = "\n")
  
  stringr::str_c("case_when(\n", 
        replacement_lines, 
        paste0("\n  T ~ ", 
               .v, "\n)")) %>% 
    cat()
}

## code to prepare `superheroes` dataset goes here
# Vector of superheroes
# Source:
# Encyclopædia Britannica, inc. 
# Published March 06, 2019
# url: https://www.britannica.com/topic/list-of-superheroes-2024795

#' Famous super heroes
#'
#' A character vector with 46 super heroes
#'
#' @format A character vector with 46 super heroes:
#' @source \url{https://www.britannica.com/topic/list-of-superheroes-2024795}
"superheroes"

superheroes <- c(
  "Ant-Man",
  "Aquaman",
  "Asterix",
  "The Atom",
  "The Avengers",
  "Batgirl",
  "Batman",
  "Batwoman",
  "Black Canary",
  "Black Panther",
  "Captain America",
  "Captain Marvel",
  "Catwoman",
  "Conan the Barbarian",
  "Daredevil",
  "The Defenders",
  "Doc Savage",
  "Doctor Strange",
  "Elektra",
  "Fantastic Four",
  "Ghost Rider",
  "Green Arrow",
  "Green Lantern",
  "Guardians of the Galaxy",
  "Hawkeye",
  "Hellboy",
  "Incredible Hulk",
  "Iron Fist",
  "Iron Man",
  "Marvelman",
  "Robin",
  "The Rocketeer",
  "The Shadow",
  "Spider-Man",
  "Sub-Mariner",
  "Supergirl",
  "Superman",
  "Teenage Mutant Ninja Turtles",
  "Thor",
  "The Wasp",
  "Watchmen",
  "Wolverine",
  "Wonder Woman",
  "X-Men",
  "Zatanna",
  "Zatara"
)

usethis::use_data(superheroes, overwrite = T)


