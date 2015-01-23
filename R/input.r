#'Create SSM input
#'
#'Create an input parameter for SSM
#' @param name character, name of the input
#' @param description character, description of the input
#' @param value numeric or character, define the value of the input
#' @param prior define the prior of the input, as returned by a \code{\link{prior}} helper
#' @param transformation define the transformation of the input (see example)
#' @export
#' @seealso \code{\link{prior}}
#' @examples \dontrun{
#'  TODO
#'}
input <- function(name, description=NULL, value=NULL, prior=NULL, transformation=NULL) {

	# TODO do some check here

	if(!is.null(value) && is.null(prior)){

		# define dirac on value
		prior <- dirac(value)

	}

	list(name=name, description=description, value=value, prior=prior, transformation=transformation)
	
}