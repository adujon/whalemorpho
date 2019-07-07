# Whale morphometrics
This R function was used to extract morphometrics from humpack whale pictures collected using unmanned aerial vehicles. The resuts where published in Ecosphere:

Christiansen, F., Dujon, A.M., Sprogis, K.R., Arnould, J.P.Y., and Bejder, L. 2016. Noninvasive unmanned aerial vehicle provides estimates of the energetic cost of reproduction in humpback whales. Ecosphere 7(10): e01468.

<b>The publication is available for free at</b>: https://esajournals.onlinelibrary.wiley.com/doi/full/10.1002/ecs2.1468

The metrics are calculated using multiple reference points placed by the user on the photograph of the body of the whale (Fig. S1).

![alt text](https://github.com/adujon/whalemorpho/blob/master/whalepic.jpg)

# List of extracted metrics:<br>

• <b>Rostrum.X</b>: The distance in X between the rostrum and the bottom-left corner of the full picture (in % of total width (X) of the photo).

• <b>Rostrum.Y</b>: The distance in Y between the rostrum and the bottom-left corner of the full picture (in % of total height (Y) of the photo).

• <b>Fluke.X</b>: The distance in X between the notch of the tail fluke and the bottom-left corner of the full picture (in % of total width (X) of the photo).

• <b>Fluke.Y</b>: The distance in Y between the notch of the tail fluke and the bottom-left corner of the full picture (in % of total height (Y) of the photo).

• <b>Total.length.pix</b>: Total length of the whale (in pixels).

• <b>Length.to.blowhole.pix</b>: The length between the rostrum and the blowhole of the whale (in pixels).

• <b>Length.to.start.of.dorsal.fin.pix</b>: The length between the rostrum and the beginning of the dorsal fin of the whale (in pixels).

• <b>Length.to.end.of.dorsal.fin.pix</b>: The length between the rostrum and the end of the dorsal fin of the whale (in pixels).

• <b>Length.to.start.of.fluke.pix</b>: The length between the rostrum and the start of the tail of the whale (in pixels).

• <b>Length.to.eyes.pix</b>: The length between the rostrum and the line of the eyes of the whale (in pixels).

• <b>Width.at.eyes.pix</b>: The width between the eyes of the whale (in pixels).

• <b>Width.fluke.pix</b>: The length between the two extremities of the tail fluke (in pixels).

• <b>Width.5.proc.pix to Width.95.proc.pix</b>: Width measurements of the body of the whale (in pixels).

# Usage 
whale.morpho(myimage, tiff)

# Arguments 
<b>myimage:</b> Path to the picture of the whale. The picture must be JPEG or TIFF format.
<b>tiff:</b> Set to TRUE if the picture is a TIFF. Set to FALSE if the picture is a JPEG.

# Example

rm(list=ls()) # clear all the files in memory<br>
#load the packages required to run the whale.morpho function<br>
library(jpeg)<br>
library(tiff)<br>
library(raster)<br>
source("whale.morpho.R")<br>
#Run the function for a JPEG picture<br>
res <- whale.morpho(myimage = "C:/Whales/whale_picture.jpg", TIFF = FALSE)<br>
res<br>
#Run the function for a TIFF picture<br>
res <- whale.morpho(myimage = "C:/Whales/whale_picture.tif", TIFF = TRUE)<br>
res<br>
</code><br>

# Note
When running your script, make sure not to run anything past the code line
launching the whale.morpho function, otherwise the function will crash. First run your script
up to the line calling the whale.morpho function, analyze your picture, and after that run the
end of your script.
