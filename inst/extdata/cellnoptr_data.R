library(CNORode)
library(magrittr)
library(dplyr)
library(stringr)
data(ToyModel)
data(CNOlistToy)
cnolist <- CNOlist(CNOlistToy)
plotModel(model, cnolist)
# Pruning
toy_data <- CNOlistToy$valueSignals %>%
  {
    for(i in 1:length(.)){
    names(.)[i] <- paste("t", CNOlistToy$timeSignals[i], sep = "")
    }
    return(.)
  } %>%
  lapply(function(mat){
    as.data.frame(cbind(mat,
                        CNOlistToy$valueStimuli,
                        CNOlistToy$valueInhibitors
    )) %>%
      {
        names(.) <- c(CNOlistToy$namesSignals,
               paste0("stim_", CNOlistToy$namesStimuli),
               paste0("inh_", CNOlistToy$namesInhibitors))
       return(.)
      }
    }) %>%
  {
    for(i in 1:length(.)){
      .[[i]] <- cbind(.[[i]], timepoint = names(.)[i])
    }
    return(.)
    } %>%
  {do.call("rbind", .)}
devtools::use_data(toy_data, overwrite=TRUE)