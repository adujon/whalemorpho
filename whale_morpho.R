################################################################################
################################################################################
#whale.morpho function in R: Script to extract morphometric measurements of humpback whales from aerial photographs.
#Developed by: Antoine M. Dujon (antoine.dujon@yahoo.fr)
#Title: Noninvasive unmanned aerial vehicle provides estimates of the energetic cost of reproduction in humpback whales
#Journal: Ecosphere (DOI: 10.1002/ecs2.1468)
#Authors: Fredrik Christiansen, Antoine M. Dujon, Kate R. Sprogis, John P.Y. Arnould and Lars Bejder
################################################################################
################################################################################


### Load the packages that will be used by the function
library(jpeg)
library(tiff)
library(raster)

bcn <- 0 # Reset the bcn counter to zero (this counter is used during the validation of the points by the user) 

whale.morpho <- function(myimage, TIFF){
  

### Import the whale picture
if(TIFF == TRUE){
  pic <- readTIFF(myimage, native = T) 
} else {
  pic <- readJPEG(myimage) 
}

#########################################################################
######################  Zoom in on the whale  body ######################
#########################################################################

### Plot the whale picture
plot(x = 0, y = 0, type = 'n', xlim  = c(0,dim(pic)[2]), ylim  = c(0,dim(pic)[1]), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1])

### Select the bottom left corner
bcn <- 0 # Reset the bcn counter to zero (this counter is used during the validation of the points by the user) 
while(bcn == 0){
  
plot(x = 0, y = 0, type = 'n', xlim  = c(0,dim(pic)[2]), ylim  = c(0,dim(pic)[1]), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1])  
  
print('###### Click on the bottom left corner for zooming.')
flush.console()
bottom.left <- locator(n=1)

### Select the top right corner
print('###### Click on the top right corner for zooming.')
flush.console()
top.right <- locator(n=1)

### Replot the whale picture
plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1])

### Add a manual verification by the user
bcn <- as.numeric(readline(prompt='###### Keep the zoomed area? Yes = 1 No = 0 : ')) 

}

################################################################
################ Compute simple distance metrics ###############
################################################################

### Locate the tip of the rostrum
bcn <- 0
while(bcn == 0){

plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1]) 

print('###### Click on the tip of the rostrum.')
flush.console()
rostrum <- locator(n = 1)
rostrum <- c(rostrum$x, rostrum$y)
points(rostrum[1], rostrum[2], pch = 20)

### Add a manual verification by the user
bcn <- as.numeric(readline(prompt='###### Keep the rostrum location? Yes = 1 No = 0  : ')) 

}

###########################################################
###########################################################

### Locate the notch of the tail fluke
bcn <- 0
while(bcn == 0){
  
### Plot the whale 
plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1]) 
points(rostrum[1], rostrum[2], pch = 20)
  
print('###### Click on the notch of the tail fluke.')
flush.console()
tail<- locator(n = 1)
tail <- c(tail$x, tail$y)
points(tail[1], tail[2], pch = 20)

### Add a manual verification by the user
bcn <- as.numeric(readline(prompt='###### Keep the tail fluke location? Yes = 1 No = 0  : ')) 

}

### Compute L metric
L <- sqrt((tail[1] - rostrum[1])^2 + (tail[2] - rostrum[2])^2)

############################################################
############################################################

### Locate the eyes
bcn <- 0
while(bcn == 0){
  
### Plot the whale 
plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1]) 
points(rostrum[1], rostrum[2], pch = 20)  
points(tail[1], tail[2], pch = 20)

print('###### Click on one of the two eyes')
flush.console()
eye1 <- locator(n = 1)
points(eye1$x, eye1$y, pch = 20, col = 'blue')

#### Create a perpendicular line ####

seq.whale.x <- seq(rostrum[1], tail[1], 0.1 * sign(tail[1]-rostrum[1]))
seq.whale.y <- seq(rostrum[2], tail[2], length.out = length(seq.whale.x))
dist.eye<- sqrt((eye1$x - seq.whale.x)^2 + (eye1$y - seq.whale.y)^2)
sel.min.eye <- which(dist.eye == min(dist.eye))

### Add a manual verification by the user
bcn <- as.numeric(readline(prompt='###### Keep the location of the first eye? Yes = 1 No = 0  : ')) 

}

##### Compute rotation to create the line to determine the second eye location

### Intermediate step 
selx <- seq.whale.x[sel.min.eye]
sely <- seq.whale.y[sel.min.eye]
dx <- eye1$x - selx
dy <- eye1$y - sely
eyeline <- c()
DX <- (eye1$x - selx)
DY <- (eye1$y - sely)
eyeline$x <- cos(pi) * DX * 100 - sin(pi) * DY * 100 + selx #100 is a scaling factor used to make sure the line is long enought
eyeline$y <- sin(pi) * DX * 100 + cos(pi) * DY * 100 + sely 

### Locate the second eye 
bcn <- 0
while(bcn == 0){
  
  ### Plot the whale 
  plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
  rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1]) 
  points(rostrum[1], rostrum[2], pch = 20)  
  points(tail[1], tail[2], pch = 20)
  points(eye1$x, eye1$y, pch = 20, col = 'blue')
  
  ### Locate the second eye
  print('###### Click to locate the second eye')
  flush.console()
  eye2 <- locator(n = 1) 
  
  ### Create a sequence of points to help locate the second eye
  b <- (eyeline$x -  eye1$x)/10000
  seq.eye.x <- seq(eye1$x, eyeline$x, b)
  seq.eye.y <- seq(eye1$y, eyeline$y, length.out = length(seq.eye.x))
  
  dist.eye2<- sqrt((eye2$x - seq.eye.x)^2 + (eye2$y - seq.eye.y)^2)
  sel.min.eye2<- which(dist.eye2 == min(dist.eye2))
  
  ### Locate the closest point
  eye2$x <- seq.eye.x[sel.min.eye2]
  eye2$y <- seq.eye.y[sel.min.eye2]
  
  points(eye2$x, eye2$y, pch = 20, col = 'blue')
  
  ### Add a manual verification by the user
  bcn <- as.numeric(readline(prompt='###### Keep the location of the second eye? Yes = 1 No = 0  : ')) 
   
}

### Compute Leye and Weye
Leye <- sqrt((selx - rostrum[1])^2 + (sely - rostrum[2])^2)
Weye <- sqrt((eye1$x - eye2$x)^2 + (eye1$y - eye2$y)^2)

### Locate the blowhole
bcn <- 0
while(bcn == 0){

### Plot the whale 
plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1]) 
points(rostrum[1], rostrum[2], pch = 20)  
points(tail[1], tail[2], pch = 20)
points(eye2$x, eye2$y, pch = 20, col = 'blue')
points(eye1$x, eye1$y, pch = 20, col = 'blue')
  
### Locate the blowhole
print('###### Click on the blowhole.')
flush.console()
blowhole <- locator(n = 1)

dist.blow<- sqrt((blowhole$x - seq.whale.x)^2 + (blowhole$y - seq.whale.y)^2)
sel.min.blow <- which(dist.blow == min(dist.blow))

### Intermediate step
selbx <- seq.whale.x[sel.min.blow]
selby <- seq.whale.y[sel.min.blow]
points(selbx, selby, col = 'yellow', pch = 20)

### Add a manual verification by the user
bcn <- as.numeric(readline(prompt='###### Keep the blowhole location? Yes = 1 No = 0  : ')) 

}

### Compute Lb
Lb <- sqrt((rostrum[1] - selbx)^2 + (rostrum[2] - sely)^2)

############################################################################
########################   Ld1 calculation   ###############################
############################################################################

### Locate the start of the dorsal fin
bcn <- 0
while(bcn == 0){

### Plot the whale 
plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1]) 
points(rostrum[1], rostrum[2], pch = 20)  
points(tail[1], tail[2], pch = 20)
points(eye2$x, eye2$y, pch = 20, col = 'blue')
points(eye1$x, eye1$y, pch = 20, col = 'blue')
points(selbx, selby, col = 'yellow', pch = 20)

### Locate the start of the dorsal fin
print('###### Click on the start of the dorsal fin')
flush.console()
bfin <- locator(n = 1)

dist.bfin<- sqrt((bfin$x - seq.whale.x)^2 + (bfin$y - seq.whale.y)^2)
sel.min.bfin <- which(dist.bfin == min(dist.bfin))

sel.bfin.x <- seq.whale.x[sel.min.bfin]
sel.bfin.y <- seq.whale.y[sel.min.bfin]

points(sel.bfin.x, sel.bfin.y, pch = 20, col = 'orange')

### Add a manual verification by the user
bcn <- as.numeric(readline(prompt='###### Keep the start of the dorsal fin? Yes = 1 No = 0  : ')) 

}

### Compute Ld1
Ld1 <- sqrt((rostrum[1] - sel.bfin.x)^2 + ((rostrum[2] - sel.bfin.y)^2))

############################################################################
########################   Ld2 calculation   ###############################
############################################################################

bcn <- 0
while(bcn == 0){

### Plot the whale 
plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1]) 
points(rostrum[1], rostrum[2], pch = 20)  
points(tail[1], tail[2], pch = 20)
points(eye2$x, eye2$y, pch = 20, col = 'blue')
points(eye1$x, eye1$y, pch = 20, col = 'blue')
points(selbx, selby, col = 'yellow', pch = 20)  
points(sel.bfin.x, sel.bfin.y, pch = 20, col = 'orange')
  
### Locate the end of the dorsal fin ######
print('###### Click on the end of the dorsal fin?')
flush.console()
efin <- locator(n = 1)

dist.efin<- sqrt((efin$x - seq.whale.x)^2 + (efin$y - seq.whale.y)^2)
sel.min.efin <- which(dist.efin == min(dist.efin))

sel.efin.x <- seq.whale.x[sel.min.efin]
sel.efin.y <- seq.whale.y[sel.min.efin]

points(sel.efin.x, sel.efin.y, pch = 20, col = 'orange')

### Add a manual verification by the user
bcn <- as.numeric(readline(prompt='###### Keep the end of the dorsal fin? Yes = 1 No = 0  : ')) 

}

### Compute Ld2
Ld2 <- sqrt((rostrum[1] - sel.efin.x)^2 + ((rostrum[2] - sel.efin.y)^2))


############################################################################
########################   Lt calculation   ################################
############################################################################


bcn <- 0
while(bcn == 0){

### Plot the whale 
plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1]) 
points(rostrum[1], rostrum[2], pch = 20)  
points(tail[1], tail[2], pch = 20)
points(eye2$x, eye2$y, pch = 20, col = 'blue')
points(eye1$x, eye1$y, pch = 20, col = 'blue')
points(selbx, selby, col = 'yellow', pch = 20)  
points(sel.bfin.x, sel.bfin.y, pch = 20, col = 'orange')  
points(sel.efin.x, sel.efin.y, pch = 20, col = 'orange')  
  
### Locate the beginning of the tail fluke ######
print('###### Click on the beginning of the tail fluke')
flush.console()
stail <- locator(n = 1)

dist.stail<- sqrt((stail$x - seq.whale.x)^2 + (stail$y - seq.whale.y)^2)
sel.min.stail <- which(dist.stail == min(dist.stail))

sel.stail.x <- seq.whale.x[sel.min.stail]
sel.stail.y <- seq.whale.y[sel.min.stail]

points(sel.stail.x, sel.stail.y, pch = 20, col = 'green')

### Add a manual verification by the user
bcn <- as.numeric(readline(prompt='###### Keep the start of the tail fluke? Yes = 1 No = 0  : ')) 

}

### Compute Lt, Ld1 and Ld2

Lt <- sqrt((rostrum[1] - sel.stail.x)^2 + ((rostrum[2] - sel.stail.y)^2))
Ld1 <- sqrt((rostrum[1] - bfin$x)^2 + ((rostrum[2] - bfin$y)))
Ld2 <- sqrt((rostrum[1] - efin$x)^2 + ((rostrum[2] - efin$y)))

############################################################################
########################   Fw calculation   ################################
############################################################################

# Locate the tail fluke extremities
bcn <- 0
while(bcn == 0){
  ### Plot the whale 
  plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
  rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1]) 
  points(rostrum[1], rostrum[2], pch = 20)  
  points(tail[1], tail[2], pch = 20)
  points(eye2$x, eye2$y, pch = 20, col = 'blue')
  points(eye1$x, eye1$y, pch = 20, col = 'blue')
  points(selbx, selby, col = 'yellow', pch = 20)  
  points(sel.bfin.x, sel.bfin.y, pch = 20, col = 'orange')  
  points(sel.efin.x, sel.efin.y, pch = 20, col = 'orange')  
  points(sel.stail.x, sel.stail.y, pch = 20, col = 'green')
  
  print('###### Click on the two extremities of the tail fluke.')
  flush.console()
  tailfluke <- locator(n = 2)
  points(tailfluke$x, tailfluke$y, pch = 20, col = 'red')
  
  ### Add a manual verification by the user
  bcn <- as.numeric(readline(prompt='###### Keep the location of the extremities of the fluke? Yes = 1 No = 0  : ')) 
  
}

# Compute FW metric 
Fw <- sqrt(diff(tailfluke$x)^2 + diff(tailfluke$y)^2)

############################################################################
#################   Determine the various body width lines   ###############
############################################################################
plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1])
lines(x = c(rostrum[1], tail[1]), y = c(rostrum[2], tail[2]))

##### Determine the angle between the horizontal and L
angle <- atan((tail[2] - rostrum[2])/(tail[1] - rostrum[1]))#in radians

#### Define the 20 segments
seg.x <- seq(rostrum[1], tail[1], length.out = 21)
seg.y <- seq(rostrum[2], tail[2], length.out = 21)
points(seg.x, seg.y, pch = 20)

xn <- seg.x - seg.x[1]
yn <- seg.y - seg.y[1] 

### Align the points to the x axis
an <- -angle
xp <- xn * cos(an) - yn * sin(an)
yp <- xn * sin(an) + yn * cos(an)

### Compute the lines
xup <- xp  
yup <- yp + 1000

xlow <- xp  
ylow <- yp - 1000

xupr <- xup * cos(angle) - yup * sin(angle)
yupr <- xup * sin(angle) + yup * cos(angle) 

xlowr <- xlow * cos(angle) - ylow * sin(angle) 
ylowr <- xlow * sin(angle) + ylow * cos(angle) 

xlowr <- xlowr + seg.x[1]
ylowr <- ylowr + seg.y[1]

xupr <- xupr + seg.x[1]
yupr <- yupr + seg.y[1]

for(i in 2:(length(xupr)-1)){
  lines(x = c(xlowr[i], xupr[i]), y = c(ylowr[i], yupr[i]))
}

### Determine the body widths
W <- c() # Empty vector to store the body width values
m <- 2:(length(xupr)-1)
for(j in 2:(length(m)+1)){
  
  bcn <- 0
  
  {while(bcn == 0){
    name.display <- paste('Click on the red line to define W', (j-1), ' extremities', sep = '')
    
    ### Plot the whale
    plot(x = 0, y = 0, type = 'n', xlim  = c(bottom.left$x,top.right$x), ylim  = c(bottom.left$y,top.right$y), xlab = 'X (Pixels)', ylab = 'Y (Pixels)', asp =1)
    rasterImage(pic, 0, 0, dim(pic)[2],dim(pic)[1])
    lines(x = c(rostrum[1], tail[1]), y = c(rostrum[2], tail[2]))
     
    for(i in 2:(length(xupr)-1)){
      lines(x = c(xlowr[i], xupr[i]), y = c(ylowr[i], yupr[i]))
    }
    
    lines(x = c(xlowr[j], xupr[j]), y = c(ylowr[j], yupr[j]), col = 'red')
  
    ### Locate the two points on the whale
    print(name.display)
    flush.console()
    width <- locator(n = 2)
    
    ### Create a sequence for whale width
    b <- (xupr[j] - xlowr[j])/100000
    seqw.x <- seq(xlowr[j], xupr[j], b)
    seqw.y <- seq(ylowr[j], yupr[j], length.out = length(seqw.x))
    
    ### Find the closest distance on the line
    distsel1 <- sqrt((width$x[1] - seqw.x)^2 + (width$y[1] - seqw.y)^2)
    distsel2 <- sqrt((width$x[2] - seqw.x)^2 + (width$y[2] - seqw.y)^2)
    
    #### Replace the points in the width vector
    width$x[1] <- seqw.x[which(distsel1 == min(distsel1))]
    width$y[1] <- seqw.y[which(distsel1 == min(distsel1))]
    
    width$x[2] <- seqw.x[which(distsel2 == min(distsel2))]
    width$y[2] <- seqw.y[which(distsel2 == min(distsel2))]
    
    points(x = width$x, y = width$y, pch = 20, col = 'black')
    
    ######### add a manual checking by the user
      bcn <- as.numeric(readline(prompt='###### Keep the two points? Yes = 1 No = 0  : ')) 
  
  }}
  
  W[j-1] <- sqrt(diff(width$x)^2 + diff(width$y)^2)
  
}

### Create the final data.frame with all the mesurements
vec.export<-c(                                                                    
  Image.ID = 0,                                                                   # The frame number of the .jpg file (temporary filled with a zero)
  Rostrum.X=(rostrum[1]/ncol(pic))*100,                                           # The distance in X between the rostrum and the bottom-left corner of the full picture (in % of total width (X) of the photo)
  Rostrum.Y=(rostrum[2]/nrow(pic))*100,                                           # The distance in Y between the rostrum and the bottom-left corner of the full picture (in % of total height (Y) of the photo)
  Fluke.X=(tail[1]/ncol(pic))*100,                                                # The distance in X between the notch of the tail fluke and the bottom-left corner of the full picture (in % of total width (X) of the photo) 
  Fluke.Y=(tail[2]/nrow(pic))*100,                                                # The distance in Y between the notch of the tail fluke and the bottom-left corner of the full picture (in % of total height (Y) of the photo)
  Total.length.pix=L,                                                             # Total length of the whale (in pixels)
  Length.to.blowhole.pix=Lb,                                                      # The length between the rostrum and the blowhole of the whale (in pixels)
  Length.to.start.of.dorsal.fin.pix=Ld1,                                          # The length between the rostrum and the beginning of the dorsal fin of the whale (in pixels)
  Length.to.end.of.dorsal.fin.pix=Ld2,                                            # The length between the rostrum and the end of the dorsal fin of the whale (in pixels)
  Length.to.start.of.fluke.pix=Lt,                                                # The length between the rostrum and the start of the tail of the whale (in pixels)
  Length.to.eyes.pix=Leye,                                                        # The length between the rostrum and the line of the eyes of the whale (in pixels)
  Width.at.eyes.pix=Weye,                                                         # The length betweeb the two extremities of the fluke
  Width.fluke.pix=Fw)                                                             # The width between the eyes of the whale (in pixels))                                                             #The width of the tail fluke (in pixels)

### Create the export data frame and match the line names with the metrics values
names(W)<-paste("Width.",seq(5,95,5),".proc.pix",sep="")   
vec.export <- c(vec.export, W)
vec.export <- sprintf("%.3f", round(vec.export,3))
vec.export[1] <-as.character(myimage) 

export<- data.frame(vec.export)
names(export) <- 'Metrics'
row.names(export) <- c('Image.ID', 
                      'Rostrum.X', 
                      'Rostrum.Y', 
                      'Fluke.X', 
                      'Fluke.Y',
                      'Total.length.pix',
                      'Length.to.blowhole.pix', 
                      'Length.to.start.of.dorsal.fin.pix',
                      'Length.to.end.of.dorsal.fin.pix',
                      'Length.to.start.of.fluke.pix',
                      'Length.to.eyes.pix',
                      'Width.at.eyes.pix',
                      'Width.fluke.pix',
                      paste("Width.",seq(5,95,5),".proc.pix",sep=""))

### End of the function
print('***********  Measurements completed **********')
flush.console()
return(export)
}
