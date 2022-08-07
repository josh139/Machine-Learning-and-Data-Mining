###############################################################################
# REFRESH
###############################################################################
rm(list=ls())
###############################################################################
# ALL LIBRARIES USED IN THIS SCRIPT
###############################################################################
library(readxl)
library(NbClust)
library(fpc)
###############################################################################
# READ IN DATASET
###############################################################################
file <- "ENTER vehicles.xlsx FILE PATH"
vehicles <- read_excel(file)
vehicles
###############################################################################
# BOXPLOT vehicles
###############################################################################
boxplot(vehicles[,-c(1,20)])
###############################################################################
# CREATE A VALUE WITH THE OUTLIER INSIDE
###############################################################################
Rad.Ra_out <- boxplot.stats(vehicles$Rad.Ra)$out
Rad.Ra_out
Pr.Axis.Ra_out <- boxplot.stats(vehicles$Pr.Axis.Ra)$out
Pr.Axis.Ra_out
Max.L.Ra_out <- boxplot.stats(vehicles$Max.L.Ra)$out
Max.L.Ra_out
Sc.Var.Maxis_out <- boxplot.stats(vehicles$Sc.Var.Maxis)$out
Sc.Var.Maxis_out
Sc.Var.maxis_out <- boxplot.stats(vehicles$Sc.Var.maxis)$out
Sc.Var.maxis_out
Skew.Maxis_out <- boxplot.stats(vehicles$Skew.Maxis)$out
Skew.Maxis_out
Skew.maxis_out <- boxplot.stats(vehicles$Skew.maxis)$out
Skew.maxis_out
Kurt.maxis_out <- boxplot.stats(vehicles$Kurt.maxis)$out
Kurt.maxis_out
###############################################################################
# EXTRACT THE ROW NUMBER CORRESPONDING TO THE OUTLIERS
###############################################################################
Rad.Ra_row <- which(vehicles$Rad.Ra %in% Rad.Ra_out)
Rad.Ra_row
Pr.Axis.Ra_row <- which(vehicles$Pr.Axis.Ra %in% Pr.Axis.Ra_out)
Pr.Axis.Ra_row
Max.L.Ra_row <- which(vehicles$Max.L.Ra %in% Max.L.Ra_out)
Max.L.Ra_row
Sc.Var.Maxis_row <- which(vehicles$Sc.Var.Maxis %in% Sc.Var.Maxis_out)
Sc.Var.Maxis_row
Sc.Var.maxis_row <- which(vehicles$Sc.Var.maxis %in% Sc.Var.maxis_out)
Sc.Var.maxis_row
Skew.Maxis_row <- which(vehicles$Skew.Maxis %in% Skew.Maxis_out)
Skew.Maxis_row
Skew.maxis_row <- which(vehicles$Skew.maxis %in% Skew.maxis_out)
Skew.maxis_row
Kurt.maxis_row <- which(vehicles$Kurt.maxis %in% Kurt.maxis_out)
Kurt.maxis_row
out_ind <- c(Rad.Ra_row, Pr.Axis.Ra_row, Max.L.Ra_row, Sc.Var.Maxis_row, Sc.Var.maxis_row, 
             Skew.Maxis_row, Skew.maxis_row, Kurt.maxis_row)
out_ind
###############################################################################
# PRINT THE SPECIFIC ROWS IN THE DATASET WHICH HAVE OUTLIERS
###############################################################################
vehicles[out_ind, ]
###############################################################################
# REMOVE THE OUTLIERS FROM THE VEHICLES DATASET
###############################################################################
no_o_vehciles <- vehicles[-c(out_ind),]
###############################################################################
# PRINT THE OUTLIER FREE BOXPLOT
###############################################################################
boxplot(no_o_vehciles[,-c(1,20)])
###############################################################################
# SCALE OUTLIER FREE DATAFRAME
###############################################################################
data.train <- scale(no_o_vehciles[,-c(1,20)])
###############################################################################
# SHOW data.train IN BOXPLOT
###############################################################################
boxplot(data.train)
###############################################################################
# NbClust WITH EUCLIDEAN
###############################################################################
set.seed(1234)
nc <- NbClust(data.train, distance="euclidean", min.nc=2, max.nc=4, method="kmeans", 
              index="all")
table(nc$Best.n[1,])
###############################################################################
# NbClust WITH MANHATTAN
###############################################################################
set.seed(1234)
nc <- NbClust(data.train, distance="manhattan", min.nc=2, max.nc=4, method="kmeans", 
              index="all")
table(nc$Best.n[1,])
###############################################################################
# NbClust WITH MINKOWSKI
###############################################################################
set.seed(1234)
nc <- NbClust(data.train, distance="minkowski", min.nc=2, max.nc=4, method="kmeans", 
              index="all")
table(nc$Best.n[1,])
###############################################################################
# ATTEMPT 1 BASED OFF OF NbClust's ANALYSIS
###############################################################################
x <- data.train
y <- no_o_vehciles$Class
kc <- kmeans(x,3)
kc
plotcluster(data.train, kc$cluster)
table(y,kc$cluster)
###############################################################################
# ATTEMPT 2 WITH K=2
###############################################################################
kc <- kmeans(x,2)
kc
plotcluster(data.train, kc$cluster)
table(y,kc$cluster)