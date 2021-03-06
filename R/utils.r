remove_null <- function(x) {

	if(is.list(x)){
		x <- x[!sapply(x,is.null)]
	}

	return(x)
}

clean_args <- function(x) {
	
	x <- x %>% remove_null %>% .[!sapply(.,is.logical) | as.logical(.)] %>% unlist %>% sapply(.,function(xx) str_replace(xx,"TRUE",""))
	
	return(x)
}


get_element <- function(x, key) {

	if(is.list(x)){
		return(sapply(x, function(xx) {xx[[key]]}))
	} else {
		return(x[[key]])
	}

}

get_name <- function(x) {

	get_element(x, "name")

}


find_element <- function(x, key, value) {

	i <- sapply(x, function(xx) {xx[[key]] == value}) %>% which

	return(x[i])

}

#'Export to tracer
#'
#'Export to tracer
#' @param  path character, where to find \code{trace_*.csv}. If \code{NULL} (default), use the \code{path} of the last block (e.g. \code{/pmcmc}).
#' @param  id numeric, indicate which \code{trace_*.csv} to choose. If \code{NULL} (default), use the \code{id} of the last block (default to 0 in SSM).
#' @inheritParams call_ssm
#' @inheritParams plot_X
#' @import readr
#' @export
to_tracer <- function(ssm, path=NULL, id=NULL) {

	if(is.null(path)){

		path <- ssm$hidden$last_path
		
		if(is.null(path)){
			stop("Argument",sQuote("path"),"required", call.=FALSE)	
		}
	}


	if(!is.null(id)){

		df_trace <- sprintf("trace_%s.csv",id) %>% file.path(path,.) %>% read_csv

	} else {

		# search for all trace_* in path
		trace_files <- list.files(path) %>% grep("trace_*",.,value=TRUE)

		if(length(trace_files)==0){
			stop("No trace files in directory", dQuote(path))
		}

		if(length(trace_files)>1){
			
			# if more than one, take ssm$summary$id. If missing, send error
			id <- ssm$summary[["id"]]
			if(is.null(id)){
				stop("Use numeric argument",sQuote("id"),"to select one file among:",sQuote(trace_files))
			}
			trace_files <- sprintf("trace_%s.csv",id)

		}

		df_trace <- file.path(path,trace_files) %>% read_csv

	}


	df_trace <- data.frame(state=(1:nrow(df_trace))-1,df_trace)
	df_trace$index <- NULL

	# TODO: get id and put it
	write.table(df_trace,file=file.path(path,"tracer.txt"),row.names=FALSE,quote=FALSE,sep="\t")

	return(ssm)

}


protect <- function(x) {

	return(paste0("(",x,")"))

}


get_state_variables <- function(reactions) {

	x <- reactions %>% unlist

	x[names(x)%in%c("from","to")] %>% unique %>% return

}


# calibrate_smc <- function(ssm, n_replicate=10, n_parts=seq(100, 1000, 100), ...){

# 	browser()

# 	x <- smc(ssm, n_parts=n_parts[1], ...)

# 	x$summary[["log_likelihood"]]
	

# }


# df_tracer <- as.data.frame(my_mcmc_burn_thin_combined)


# get_args <- function(args_names) {

# 	browser()

# 	arg_names <- formals(fun=sys.function(which=2)) %>% names

# 	env <- parent.frame()

# 	args <- sapply(arg_names, get, envir=env)

# 	return(args)

# }