library(ggplot2)
library(forcats)
library(viridis)
library(MASS)
require(plyr)
library(grid)
library(dplyr)
library(Metrics)

nrel.blue = '#0079C2'
nrel.lblue = '#00A4E4'
nrel.yellow = '#F7A11A'
nrel.lyellow = '#FFC423'
nrel.green = '#5D9732'
nrel.lgreen = '#8CC63F'
nrel.orange = '#933C06'
nrel.lorange = '#D9531E'
nrel.grey = '#B2B7BB'
nrel.lgrey = '#D1D5D8'

# Plot specs
ppi = 300
pwidth.m = 11
pheight.m = 7.5
nbreaks = 10
fntsize = 24
legwidth = 1.25
legheight = 1.5
textsize = 18
linesize = 1

# Plot theme
theme.main = theme(
  plot.title          = element_text(hjust=.5, size = 12+6),
  legend.text           = element_text(hjust=.5, size = 16),
  plot.caption        = element_text(hjust=.5, size = 16),
  axis.title.x        = element_text(hjust=.5,size = 16),
  axis.title.y        = element_text(hjust=.5,size = 16),
  axis.text.y         = element_text(hjust=.5, size =16),
  axis.text.x         = element_text(hjust=.5, size =16),
  panel.grid.major.y  = element_line(color='gray', size = .3),
  panel.grid.minor.y  = element_blank(),
  panel.grid.major.x  = element_line(color='gray', size = .3),
  panel.grid.minor.x  = element_blank(),
  panel.background    = element_blank(),
  legend.position     = "right",
  axis.line.x = element_line(color="black", size = .3),
  strip.text = element_text(size = 16)
)


theme.bar = theme(
  text                = element_text(family = "Calibri", size = textsize),
  plot.title          = element_text(hjust=.5, size = textsize+6),
  plot.caption        = element_text(hjust=-.2, size = textsize-6),
  axis.title.x        = element_text(hjust=.5),
  axis.title.y        = element_text(hjust=.5),
  axis.text.x         = element_text(margin = margin(1.5, unit = "cm")),
  panel.grid.major.y  = element_line(color='gray', size = .3),
  panel.grid.minor.y  = element_blank(),
  panel.grid.major.x  = element_blank(),
  panel.grid.minor.x  = element_blank(),
  panel.background    = element_blank(),
  axis.ticks.x        = element_blank(),
  legend.position     = "none",
  plot.margin = unit(c(1,1,1.5,1.2),"cm"),
)


theme.facet = theme(
  text                = element_text(family = "Calibri", size = textsize+4),
  plot.title          = element_text(hjust=.5, size = textsize+8),
  plot.caption        = element_text(hjust=1, size = textsize-6),
  plot.subtitle       = element_text(hjust=1, size = textsize-8),
  axis.title.x        = element_text(hjust=.5),
  axis.title.y        = element_text(hjust=.5),
  axis.text.y         = element_text( size = textsize-4),
  axis.text.x         = element_text( angle = 45, size = textsize-4),
  panel.grid.major.y  = element_line(color='gray', size = .3),
  panel.grid.minor.y  = element_blank(),
  panel.grid.major.x  = element_line(color='gray', size = .3),
  panel.grid.minor.x  = element_blank(),
  panel.background    = element_blank(),
  legend.position     = "right",
  axis.line.x = element_line(color="black", size = .3),
  plot.margin = unit(c(1,1,1.5,1.2),"cm"),
)


theme.tilt_x = theme(
  axis.text.x         = element_text( angle = 45, vjust=0.5, size=18),
)

theme.no_legend = theme(
  legend.position     =  "none",
)


get_density <- function(x, y, n = 100) {
  dens <- MASS::kde2d(x = x, y = y, n = n)
  ix <- findInterval(x, dens$x)
  iy <- findInterval(y, dens$y)
  ii <- cbind(ix, iy)
  return(dens$z[ii])
}






######## ######## ######## Analysis ######## ######## ######## 


### PV ###

df <- read.csv('/Users/tkwasnik/github/urbanopt-example-geojson-reopt-project/compiled_SDGESolarOnly_results.csv')
df$scenario <- gsub('runSDGE/','',df$scenario)
df$scenario <- gsub('scenario','',df$scenario)
df$scenario <- gsub('_',' ',df$scenario)

ggplot(df, aes(x=scenario,y=solar_pv_size_kw)) + geom_col() + ylab("Solar PV (kW)") + xlab("") + facet_wrap(df$level)+ theme.main + theme.tilt_x +theme(axis.text=element_text(size=18))
ggplot(df, aes(x=scenario,y=storage_size_kw)) + geom_col() + ylab("Storage (kW)") + xlab("") +  facet_wrap(df$level)+ theme.main + theme.tilt_x
ggplot(df, aes(x=scenario,y=npv_us_dollars/lcc_us_dollars)) + ylab("Percent Savings") + xlab("") + geom_col() + facet_wrap(df$level) + theme.main + theme.tilt_x
ggplot(df, aes(x=scenario,y=lcc_us_dollars)) + ylab("Lifecycle Costs ($)") + xlab("") + geom_col() + facet_wrap(df$level) + theme.main + theme.tilt_x



