#' Call the example Layout 1
#'
runexample <- function(){
  shiny::runApp(
    system.file("ExampleLayout1",
                package = "ShinyPkg")
  )
}