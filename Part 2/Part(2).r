###############################################################################
# REFRESH
###############################################################################
rm(list=ls())
###############################################################################
# ALL LIBRARIES USED IN THIS SCRIPT
###############################################################################
library(readxl)
library(neuralnet)
library(grid)
library(MASS)
library(Metrics)
###############################################################################
# READ IN DATASET
###############################################################################
file <- "ENTER ExchangeUSD.xlsx FILE PATH"
ExchangeUSD <- read_excel(file)
ts_ExchangeUSD <- ts(ExchangeUSD[,3],start=c(2011,10),frequency=73)
plot(ts_ExchangeUSD)
###############################################################################
# NORMALIZE DATA
###############################################################################
normalize <- function(x) 
{
  return((x - min(x)) / (max(x) - min(x)))
}
###############################################################################
# SAVE ORIGINAL NORMALIZED DATA
###############################################################################
write.table(norm_ExchangeUSD, file="C:/Users/jbrb/OneDrive/Desktop/University/Year 2/Sem 
2/Machine Learning and Data Mining/Coursework/Cwk2/norm_ExchangeUSD.csv", row.names=F 
            ,sep=",")
###############################################################################
# READ IN THE AR DATA
###############################################################################
file <- "C:/Users/jbrb/OneDrive/Desktop/University/Year 2/Sem 2/Machine Learning and Data 
Mining/Coursework/Cwk2/norm_k1.csv"
norm_k1 <- read.csv(file)
norm_k1
file <- "C:/Users/jbrb/OneDrive/Desktop/University/Year 2/Sem 2/Machine Learning and Data 
Mining/Coursework/Cwk2/norm_k2.csv"
norm_k2 <- read.csv(file)
norm_k2
file <- "C:/Users/jbrb/OneDrive/Desktop/University/Year 2/Sem 2/Machine Learning and Data 
Mining/Coursework/Cwk2/norm_k3.csv"
norm_k3 <- read.csv(file)
norm_k3
###############################################################################
# TURN ExchangeUSD INTO MATRIX
###############################################################################
ExchangeUSD_matrix <- data.matrix(ExchangeUSD[,-c(1,2)])
ExchangeUSD_matrix
norm_ExchangeUSD <- normalize(ExchangeUSD[,-c(1,2)])
norm_ExchangeUSD
###############################################################################
# TURN NORMALIZED DATASETS INTO MATRICES
###############################################################################
norm_k1_matrix <- data.matrix(norm_k1)
col_names <- c("Yt.1", "Yt","DesiredOutput")
colnames(norm_k1_matrix) <- col_names
norm_k1_matrix
norm_k2_matrix <- data.matrix(norm_k2)
col_names <- c("Yt.2","Yt.1", "Yt","DesiredOutput")
colnames(norm_k2_matrix) <- col_names
norm_k2_matrix
norm_k3_matrix <- data.matrix(norm_k3)
col_names <- c("Yt.3","Yt.2","Yt.1", "Yt","DesiredOutput")
colnames(norm_k3_matrix) <- col_names
norm_k3_matrix
###############################################################################
# PARTITION THE DATA INTO TRAINING SET AND TEST SET
###############################################################################
norm_k1_matrix_train <- norm_k1_matrix[1:400, ]
norm_k1_matrix_test <- norm_k1_matrix[401:498, -3]
norm_k2_matrix_train <- norm_k2_matrix[1:400, ]
norm_k2_matrix_train
norm_k2_matrix_test <- norm_k2_matrix[401:497, -4]
norm_k3_matrix_train <- norm_k3_matrix[1:400, ]
norm_k3_matrix_test <- norm_k3_matrix[401:496, -5]
###############################################################################
# MODEL NEURAL NETWORK 1
###############################################################################
set.seed(12345)
ExchangeUSD_Model <- neuralnet(DesiredOutput ~ Yt + Yt.1, data = norm_k1_matrix_train, 
                               hidden=1)
plot(ExchangeUSD_Model)
###############################################################################
# USE TEST DATA ON NEURAL NETWORK 1
###############################################################################
model_results <- compute(ExchangeUSD_Model, norm_k1_matrix_test)
predicted_DesiredOutput <- model_results$net.result
cor(predicted_DesiredOutput, norm_k1_matrix_test)
head(predicted_DesiredOutput)
ExchangeUSD_k1_og_train <- ExchangeUSD_matrix[1:400, ]
ExchangeUSD_k1_og_test <- ExchangeUSD_matrix[401:498, ]
ExchangeUSD_min <- min(ExchangeUSD_k1_og_train)
ExchangeUSD_max <- max(ExchangeUSD_k1_og_train)
head(ExchangeUSD_k1_og_train)
unnormalize <- function(x, min, max) { 
  return( (max - min)*x + min )
}
ExchangeUSD_pred <- unnormalize(predicted_DesiredOutput, ExchangeUSD_min, 
                                ExchangeUSD_max)
ExchangeUSD_pred
mse <- mse(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mse
rmse <- function(error)
{
  sqrt(mean(error^2))
}
error <- (ExchangeUSD_k1_og_test - ExchangeUSD_pred)
pred_RMSE <- rmse(error) 
pred_RMSE
mape <- mape(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mape
mae <- mae(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mae
###############################################################################
# VISUALISATION PLOT 1
###############################################################################
par(mfrow=c(1,1))
plot(ExchangeUSD_k1_og_test, ExchangeUSD_pred ,col='red',main='Real vs predicted 
NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN', pch=18,col='red', bty='n')
final_result <- cbind(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
final_result
###############################################################################
# MODEL NEURAL NETWORK 2
###############################################################################
set.seed(12345)
ExchangeUSD_Model <- neuralnet(DesiredOutput ~ Yt + Yt.1, data = norm_k1_matrix_train, 
                               hidden=c(3,2))
plot(ExchangeUSD_Model)
###############################################################################
# USE TEST DATA ON NEURAL NETWORK 2
###############################################################################
model_results <- compute(ExchangeUSD_Model, norm_k1_matrix_test)
predicted_DesiredOutput <- model_results$net.result
cor(predicted_DesiredOutput, norm_k1_matrix_test)
ExchangeUSD_min <- min(ExchangeUSD_k1_og_train)
ExchangeUSD_max <- max(ExchangeUSD_k1_og_train)
head(ExchangeUSD_k1_og_train)
ExchangeUSD_pred <- unnormalize(predicted_DesiredOutput, ExchangeUSD_min, 
                                ExchangeUSD_max)
ExchangeUSD_pred
mse <- mse(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mse
error <- (ExchangeUSD_k1_og_test - ExchangeUSD_pred)
pred_RMSE <- rmse(error) 
pred_RMSE
mape <- mape(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mape
mae <- mae(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mae
###############################################################################
# VISUALISATION PLOT 2
###############################################################################
par(mfrow=c(1,1))
plot(ExchangeUSD_k1_og_test, ExchangeUSD_pred ,col='red',main='Real vs predicted 
NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN', pch=18,col='red', bty='n')
final_result <- cbind(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
final_result
###############################################################################
# MODEL NEURAL NETWORK 3
###############################################################################
set.seed(12345)
ExchangeUSD_Model <- neuralnet(DesiredOutput ~ Yt + Yt.1, data = norm_k1_matrix_train, 
                               hidden=c(3,2), threshold=0.001)
plot(ExchangeUSD_Model)
###############################################################################
# USE TEST DATA ON NEURAL NETWORK 3
###############################################################################
model_results <- compute(ExchangeUSD_Model, norm_k1_matrix_test)
predicted_DesiredOutput <- model_results$net.result
cor(predicted_DesiredOutput, norm_k1_matrix_test)
ExchangeUSD_min <- min(ExchangeUSD_k1_og_train)
ExchangeUSD_max <- max(ExchangeUSD_k1_og_train)
head(ExchangeUSD_k1_og_train)
ExchangeUSD_pred <- unnormalize(predicted_DesiredOutput, ExchangeUSD_min, 
                                ExchangeUSD_max)
ExchangeUSD_pred
mse <- mse(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mse
error <- (ExchangeUSD_k1_og_test - ExchangeUSD_pred)
pred_RMSE <- rmse(error) 
pred_RMSE
mape <- mape(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mape
mae <- mae(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mae
###############################################################################
# VISUALISATION PLOT 3
###############################################################################
par(mfrow=c(1,1))
plot(ExchangeUSD_k1_og_test, ExchangeUSD_pred ,col='red',main='Real vs predicted 
NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN', pch=18,col='red', bty='n')
final_result <- cbind(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
final_result
###############################################################################
# MODEL NEURAL NETWORK 4
###############################################################################
set.seed(12345)
ExchangeUSD_Model <- neuralnet(DesiredOutput ~ Yt + Yt.1, data = norm_k1_matrix_train, 
                               hidden=c(3,2), act.fct= 'tanh')
plot(ExchangeUSD_Model)
###############################################################################
# USE TEST DATA ON NEURAL NETWORK 4
###############################################################################
model_results <- compute(ExchangeUSD_Model, norm_k1_matrix_test)
predicted_DesiredOutput <- model_results$net.result
cor(predicted_DesiredOutput, norm_k1_matrix_test)
ExchangeUSD_min <- min(ExchangeUSD_k1_og_train)
ExchangeUSD_max <- max(ExchangeUSD_k1_og_train)
head(ExchangeUSD_k1_og_train)
ExchangeUSD_pred <- unnormalize(predicted_DesiredOutput, ExchangeUSD_min, 
                                ExchangeUSD_max)
ExchangeUSD_pred
mse <- mse(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mse
error <- (ExchangeUSD_k1_og_test - ExchangeUSD_pred)
pred_RMSE <- rmse(error) 
pred_RMSE
mape <- mape(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mape
mae <- mae(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
mae
###############################################################################
# VISUALISATION PLOT 4
###############################################################################
par(mfrow=c(1,1))
plot(ExchangeUSD_k1_og_test, ExchangeUSD_pred ,col='red',main='Real vs predicted 
NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN', pch=18,col='red', bty='n')
final_result <- cbind(ExchangeUSD_k1_og_test, ExchangeUSD_pred)
final_result
###############################################################################
# MODEL NEURAL NETWORK 5
###############################################################################
set.seed(12345)
ExchangeUSD_Model <- neuralnet(DesiredOutput ~ Yt + Yt.1 + Yt.2, data = 
                                 norm_k2_matrix_train, hidden=c(3,4), act.fct= 'tanh')
plot(ExchangeUSD_Model)
###############################################################################
# USE TEST DATA ON NEURAL NETWORK 5
###############################################################################
model_results <- compute(ExchangeUSD_Model, norm_k2_matrix_test)
predicted_DesiredOutput <- model_results$net.result
cor(predicted_DesiredOutput, norm_k2_matrix_test)
ExchangeUSD_k2_og_train <- ExchangeUSD_matrix[1:400, ]
ExchangeUSD_k2_og_test <- ExchangeUSD_matrix[401:497, ]
ExchangeUSD_min <- min(ExchangeUSD_k2_og_train)
ExchangeUSD_max <- max(ExchangeUSD_k2_og_train)
head(ExchangeUSD_k2_og_train)
ExchangeUSD_pred <- unnormalize(predicted_DesiredOutput, ExchangeUSD_min, 
                                ExchangeUSD_max)
ExchangeUSD_pred
mse <- mse(ExchangeUSD_k2_og_test, ExchangeUSD_pred)
mse
error <- (ExchangeUSD_k2_og_test - ExchangeUSD_pred)
pred_RMSE <- rmse(error) 
pred_RMSE
mape <- mape(ExchangeUSD_k2_og_test, ExchangeUSD_pred)
mape
mae <- mae(ExchangeUSD_k2_og_test, ExchangeUSD_pred)
mae
###############################################################################
# VISUALISATION PLOT 5
###############################################################################
par(mfrow=c(1,1))
plot(ExchangeUSD_k2_og_test, ExchangeUSD_pred ,col='red',main='Real vs predicted 
NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN', pch=18,col='red', bty='n')
final_result <- cbind(ExchangeUSD_k2_og_test, ExchangeUSD_pred)
final_result
###############################################################################
# MODEL NEURAL NETWORK 6
###############################################################################
set.seed(12345)
ExchangeUSD_Model <- neuralnet(DesiredOutput ~ Yt + Yt.1 + Yt.2 + Yt.3, data = 
                                 norm_k3_matrix_train, hidden=c(3,3), act.fct= 'tanh')
plot(ExchangeUSD_Model)
###############################################################################
# USE TEST DATA ON NEURAL NETWORK 6
###############################################################################
model_results <- compute(ExchangeUSD_Model, norm_k3_matrix_test)
predicted_DesiredOutput <- model_results$net.result
cor(predicted_DesiredOutput, norm_k3_matrix_test)
ExchangeUSD_k3_og_train <- ExchangeUSD_matrix[1:400, ]
ExchangeUSD_k3_og_test <- ExchangeUSD_matrix[401:496, ]
ExchangeUSD_min <- min(ExchangeUSD_k3_og_train)
ExchangeUSD_max <- max(ExchangeUSD_k3_og_train)
head(ExchangeUSD_k3_og_train)
ExchangeUSD_pred <- unnormalize(predicted_DesiredOutput, ExchangeUSD_min, 
                                ExchangeUSD_max)
ExchangeUSD_pred
mse <- mse(ExchangeUSD_k3_og_test, ExchangeUSD_pred)
mse
error <- (ExchangeUSD_k3_og_test - ExchangeUSD_pred)
pred_RMSE <- rmse(error) 
pred_RMSE
mape <- mape(ExchangeUSD_k3_og_test, ExchangeUSD_pred)
mape
mae <- mae(ExchangeUSD_k3_og_test, ExchangeUSD_pred)
mae
###############################################################################
# VISUALISATION PLOT 6
###############################################################################
par(mfrow=c(1,1))
plot(ExchangeUSD_k3_og_test, ExchangeUSD_pred ,col='red',main='Real vs predicted 
NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN', pch=18,col='red', bty='n')
final_result <- cbind(ExchangeUSD_k3_og_test, ExchangeUSD_pred)
final_result