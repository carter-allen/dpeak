\name{DpeakMotif-class}
\Rdversion{1.1}
\docType{class}
\alias{DpeakMotif-class}
\alias{show,DpeakMotif-method}
\title{Class "DpeakMotif" }
\description{
This class represents dPeak data.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("DpeakMotif", ...)}.
}
\section{Slots}{
  \describe{
    \item{\code{motif}:}{Object of class \code{"character"},
        representing a vector of motifs. }
    \item{\code{locMotif}:}{Object of class \code{"list"},
        representing list of locations of motifs in candidate regions. }
    \item{\code{peakChr}:}{Object of class \code{"character"},
        representing a vector of chromosome of each peak. }
    \item{\code{peakStart}:}{Object of class \code{"numeric"},
        representing a vector of start position of each peak. }
    \item{\code{peakEnd}:}{Object of class \code{"numeric"},
        representing a vector of end position of each peak. }
  }
}
\section{Methods}{
  \describe{
    \item{dpeakFit}{\code{signature(object = "DpeakMotif")}: fit the deconvolution model. }
    \item{show}{\code{signature(object = "DpeakMotif")}: provide brief summary of the object. }
     }
}
\author{ Dongjun Chung}
\seealso{
\code{\link{dpeakMotif}}, \code{\link{dpeakFit}}.
}
\examples{
\dontrun{
library(BSgenome.Ecoli.NCBI.20080805)
resultMotif <- dpeakMotif( peakfile="vignettes/examplePeak.txt", refGenome=Ecoli )
}}
\keyword{classes}
