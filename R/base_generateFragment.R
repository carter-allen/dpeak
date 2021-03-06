
.generateFragment <- function( object, PET,
    Lvalue=NA, Lprob=NA, Fratio=Fratio, aveFragLen=NA ) {

    # error treatment: skip peaks with no fragments

    if ( length(object) == 1 ) {
        return( matrix(NA) )
    }

    # extract estimates

    nsimul <- object$nsimul
    mu <- object$mu
    pi <- object$pi
    pi0 <- object$pi0
    minS <- object$minS
    maxS <- object$maxS
    peakstart <- object$peakstart
    peakend <- object$peakend
    nGroup <- length(mu)
    if ( PET == FALSE ) {
        delta <- object$delta
        sigma <- object$sigma
    }

    # generate signal fragments

    simG <- rep( seq_len(length(mu)), ceiling(pi*nsimul) )
    simS <- simE <- rep( NA, length(simG) )

    if ( isTRUE(PET) ) {
        simL <- sample( Lvalue, length(simG), prob=Lprob, replace=TRUE )
        simLlist <- split( simL, simG )
    } else {
        simD <- sample( c(1,0), length(simG),
            prob=c(Fratio,1-Fratio), replace=TRUE ) # strand
        simDlist <- split( simD, simG )
    }

    curLoc <- 1
    groupVec <- rep( NA, length(simG) )

    gTable <- table( simG )

    for ( g in seq_len(nGroup) ) {
        mu_g <- mu[g]
        n_g <- as.numeric(gTable)[ names(gTable) == as.character(g) ]

        if ( PET ) {
            # PET
            simLg <- simLlist[[ as.character(g) ]]

            s <- round( runif( n_g, mu_g - simLg + 1, mu_g ) )
            e <- s + simLg - 1
            s <- pmax( s, minS )
            e <- pmin( e, maxS )

            simS[ seq(from = curLoc, to = (curLoc+n_g-1)) ] <- s
            simE[ seq(from = curLoc, to = (curLoc+n_g-1)) ] <- e
        } else {
            # SET

            simDg <- simDlist[[ as.character(g) ]]
            nF <- length(which( simDg == 1 ))
            nR <- length(simDg) - nF

            readF <- round( rnorm( nF, mu_g - delta, sigma ) )
            readR <- round( rnorm( nR, mu_g + delta, sigma ) )
            s <- c( readF, readR - aveFragLen + 1 )
            e <- c( readF + aveFragLen - 1, readR )
            s <- pmax( s, minS )
            e <- pmin( e, maxS )

            simS[ seq(from = curLoc, to = (curLoc+n_g-1)) ] <- s
            simE[ seq(from = curLoc, to = (curLoc+n_g-1)) ] <- e
            simD[ seq(from = curLoc, to = (curLoc+n_g-1)) ] <- c( rep("F",nF), rep("R",nR) )
        }

        groupVec[ seq(from = curLoc, to = (curLoc+n_g-1)) ] <- rep(g,n_g)
        curLoc <- curLoc + n_g
    }

    # generate background fragments

    if ( pi0 > 0 ) {
        if ( PET ) {
            l0 <- sample( Lvalue, ceiling(nsimul*pi0), prob=Lprob, replace=TRUE )

            s <- round( runif( ceiling(nsimul*pi0),
                peakstart-l0+1, rep(peakend,length(l0)) ) )
            e <- s + l0 - 1
            s <- pmax( s, minS )
            e <- pmin( e, maxS )

            simS <- c( simS, s )
            simE <- c( simE, e )
        } else {
            d0 <- sample( c(1,0), ceiling(nsimul*pi0),
                prob=c(Fratio,1-Fratio), replace=TRUE ) # strand
            nF <- length(which( d0 == 1 ))
            nR <- length(d0) - nF
            r0F <- round( runif( nF, peakstart-delta-2*sigma+1, peakend ) )
            r0R <- round( runif( nR, peakstart, peakend+delta+2*sigma-1 ) )

            s <- c( r0F, r0R - aveFragLen + 1 )
            e <- c( r0F + aveFragLen - 1, r0R )
            s <- pmax( s, minS )
            e <- pmin( e, maxS )

            simS <- c( simS, s )
            simE <- c( simE, e )
            simD <- c( simD, rep("F",nF), rep("R",nR) )
        }
        groupVec <- c( groupVec, rep(0,ceiling(nsimul*pi0)) )
    }

    if ( isTRUE(PET) ) {
        return( data.frame( simS, simE, stringsAsFactors=FALSE ) )
    } else {
        return( data.frame( simS, simE, simD, stringsAsFactors=FALSE ) )
    }
}
