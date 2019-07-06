# whalemorpho
This R function was used to extract morphometrics from humpack whale pictures collected using unmanned aerial vehicles. The resuts where published in Ecosphere:

Christiansen, F., Dujon, A.M., Sprogis, K.R., Arnould, J.P.Y., and Bejder, L. 2016. Noninvasive unmanned aerial vehicle provides estimates of the energetic cost of reproduction in humpback whales. Ecosphere 7(10): e01468.

The publication is available for free at: https://esajournals.onlinelibrary.wiley.com/doi/full/10.1002/ecs2.1468

The metrics are calculated using multiple reference points placed by the user on the photograph of the body of the whale (Fig. S1).

The list of extracted metrics is:
• Rostrum.X: The distance in X between the rostrum and the bottom-left corner of the full picture (in % of total width (X) of the photo).
• Rostrum.Y: The distance in Y between the rostrum and the bottom-left corner of the full picture (in % of total height (Y) of the photo).
• Fluke.X: The distance in X between the notch of the tail fluke and the bottom-left corner of the full picture (in % of total width (X) of the photo).
• Fluke.Y: The distance in Y between the notch of the tail fluke and the bottom-left corner of the full picture (in % of total height (Y) of the photo).
• Total.length.pix: Total length of the whale (in pixels).
• Length.to.blowhole.pix: The length between the rostrum and the blowhole of the whale (in pixels).
• Length.to.start.of.dorsal.fin.pix: The length between the rostrum and the beginning of the dorsal fin of the whale (in pixels).
• Length.to.end.of.dorsal.fin.pix: The length between the rostrum and the end of the dorsal fin of the whale (in pixels).
• Length.to.start.of.fluke.pix: The length between the rostrum and the start of the tail of the whale (in pixels).
• Length.to.eyes.pix: The length between the rostrum and the line of the eyes of the whale (in pixels).
• Width.at.eyes.pix: The width between the eyes of the whale (in pixels).
• Width.fluke.pix: The length between the two extremities of the tail fluke (in pixels).
• Width.5.proc.pix to Width.95.proc.pix: Width measurements of the body of the whale (in pixels).

Usage
whale.morpho(myimage, tiff)

Arguments
myimage: Path to the picture of the whale. The picture must be JPEG or TIFF format.
tiff: Set to TRUE if the picture is a TIFF. Set to FALSE if the picture is a JPEG.

Example
rm(list=ls()) # clear all the files in memory
### load the packages required to run the whale.morpho function
library(jpeg)
library(tiff)
library(raster)
source("whale.morpho.R")
#Run the function for a JPEG picture
res <- whale.morpho(myimage = "C:/Whales/whale_picture.jpg", TIFF = FALSE)
res
#Run the function for a TIFF picture
res <- whale.morpho(myimage = "C:/Whales/whale_picture.tif", TIFF = TRUE)
res

#NOTE: When running your script, make sure not to run anything past the code line
launching the whale.morpho function, otherwise the function will crash. First run your script
up to the line calling the whale.morpho function, analyze your picture, and after that run the
end of your script.
