###########  Data cleansing  #####
setwd("~/")
Reg_data <- read.csv("Tim_Data.csv")

Reg_data <- subset(Reg_data, select = -c(RTRS.Control.Number, When.Issued.Indicator,
Assumed.Settlement.Date, Settlement.Date, Weighted.Price.Indicator, 
RTRS.Publish.Date, RTRS.Publish.Time, Version.Number))

library(dplyr)
columns.with.NA <- colnames(Reg_data)[apply(Reg_data, 2, anyNA)] # identifying the columns with NAs

average.missing.value <- apply(Reg_data[, colnames(Reg_data) %in% columns.with.NA],
2,mean,na.rm = TRUE) # calculating average value of columns.with.NA

Reg_data$X10.Year.Treasury.Constant.Maturity.Rate..Percent..Daily..Not.Seasonally.Adjusted <-
  ifelse(is.na(Reg_data$X10.Year.Treasury.Constant.Maturity.Rate..Percent..Daily..Not.Seasonally.Adjusted),
         average.missing.value[1],Reg_data$X10.Year.Treasury.Constant.Maturity.Rate..Percent..Daily..Not.Seasonally.Adjusted)

Reg_data$Interest.rate.of.the.issue.traded <-  ifelse(is.na(Reg_data$Interest.rate.of.the.issue.traded),
    average.missing.value[2],Reg_data$Interest.rate.of.the.issue.traded)

Reg_data$The.yield.of.the.trade <- ifelse(is.na(Reg_data$The.yield.of.the.trade),
    average.missing.value[3],Reg_data$The.yield.of.the.trade)

Reg_data$Unable.to.Verify.Dollar.Price.Indicator..if.applicable. <- 
  sub("^$", "N", Reg_data$Unable.to.Verify.Dollar.Price.Indicator..if.applicable.) %>%
  as.factor()
Reg_data$Alternative.Trading.System..ATS..Indicator <-
  sub("^$", "N", Reg_data$Alternative.Trading.System..ATS..Indicator) %>%
  as.factor()

Reg_data$Non.Transaction.Based.Compensation.Arrangement..NTBC..Indicator <-
  sub("^$", "N", Reg_data$Non.Transaction.Based.Compensation.Arrangement..NTBC..Indicator) %>%
  as.factor()

Reg_data$Brokers.Broker.Indicator <- 
  sub("^$", "N", Reg_data$Brokers.Broker.Indicator) %>%
  as.factor()

Reg_data$List.Offering.Price.Takedown.Indicator <- 
  sub("^$", "N", Reg_data$List.Offering.Price.Takedown.Indicator) %>%
  as.factor()

Reg_data$Trade.Type.Indicator <- 
  sub("^$", "N", Reg_data$Trade.Type.Indicator) %>%
  as.factor()

Reg_data$Trade.Date <- 
  as.POSIXct(strptime(as.character(Reg_data$Trade.Date), format = "%Y-%m-%d %H:%M:%S", tz = "UTC"))

Reg_data$Dated.date.of.the.issue.traded <- 
  as.POSIXct(strptime(as.character(Reg_data$Dated.date.of.the.issue.traded), format = "%Y/%m/%d"))  

Reg_data$Maturity.date.of.the.issue.traded <- 
  as.POSIXct(strptime(as.character(Reg_data$Maturity.date.of.the.issue.traded), format = "%Y/%m/%d")) 

Reg_data$Time.of.Trade <- as.POSIXct(strptime(as.character(Reg_data$Time.of.Trade), format = "%H:%M:%S"))

Reg_data <- Reg_data[-c(which(is.na(Reg_data$Dated.date.of.the.issue.traded), arr.ind=TRUE), 
which(is.na(Reg_data$Maturity.date.of.the.issue.traded), arr.ind=TRUE)),]

########## Regression Model ############

set.seed(123)
dt = sort(sample(1:nrow(Reg_data), 0.7*nrow(Reg_data)))
train <- Reg_data[dt,]
test <- Reg_data[-dt,]

reg_formula <- Dollar.Price.of.the.trade ~ 
  Trade.Date +
  Trade.Type.Indicator +
  Dated.date.of.the.issue.traded +
  Maturity.date.of.the.issue.traded +
  Time.of.Trade +
  The.par.value.of.the.trade +
  Brokers.Broker.Indicator +
  List.Offering.Price.Takedown.Indicator +
  Unable.to.Verify.Dollar.Price.Indicator..if.applicable. +
  Alternative.Trading.System..ATS..Indicator +
  Non.Transaction.Based.Compensation.Arrangement..NTBC..Indicator +
  X10.Year.Treasury.Constant.Maturity.Rate..Percent..Daily..Not.Seasonally.Adjusted +
  Interest.rate.of.the.issue.traded +
  The.yield.of.the.trade

reg_dollar.price <- lm(reg_formula, data = train)

## Plot: Actual Price vs. Predicted Price ##

library(ggplot2)
test_predict <- predict(reg_dollar.price, test)
ggplot(test, aes(x = c(1:length(Dollar.Price.of.the.trade)))) + 
  geom_line(aes(y = Dollar.Price.of.the.trade, color = "Actual")) + 
  geom_line(aes(y = test_predict, color = "Predicted")) +
  scale_x_log10() +
  labs(x = "Index of Observations", 
       y = "Price of Each Trade",
       title = "Regression Model: Actual Price vs. Predicted Price",
       subtitle = "Created by Bond Intelligence Inc") +
  theme(plot.title = element_text(hjust = 0.5, face="bold", color="black", size = 16)) +
  theme(plot.subtitle = element_text(hjust = 0.5, size = 10))


  ## R squared value, root squared mean error, and mean absolute error of the regression model ##

  library(caret)
data.frame(R2 = R2(test_predict, test$Dollar.Price.of.the.trade),
           RMSE = RMSE(test_predict, test$Dollar.Price.of.the.trade),
           MAE = MAE(test_predict, test$Dollar.Price.of.the.trade))

###########  Keras Neural Network Model ####################

install.packages("keras")
install.packages("tensorflow")
library(keras)
library(tensorflow)
install_keras(tensorflow = "2.2.0")
install_tensorflow(version = "nightly")

Reg_keras <- Reg_data %>% 
  subset(select = -c(Security.Description, CUSIP)) %>%
  lapply(as.numeric) %>%
  as.data.frame()

  set.seed(123)
dt = sort(sample(1:nrow(Reg_keras), 0.7*nrow(Reg_keras)))
train <- Reg_keras[dt,]
test <- Reg_keras[-dt,]

train_data <- subset(train, select = -Dollar.Price.of.the.trade)
train_label <- train$Dollar.Price.of.the.trade
test_data <- subset(test, select = -Dollar.Price.of.the.trade)
test_label <- test$Dollar.Price.of.the.trade

train_data <- scale(train_data)
col_means_train <- attr(train_data, "scaled:center") 
col_stddevs_train <- attr(train_data, "scaled:scale")
test_data <- scale(test_data, center = col_means_train, scale = col_stddevs_train)

build_model <- function() {
  model <- keras_model_sequential() %>%
    layer_dense(units = 20, activation = "sigmoid",
                input_shape = ncol(train_data)) %>%
    layer_dense(units = 20, activation = "sigmoid") %>%
    layer_dense(units = 1)
  model %>% compile(
    loss = "mse",
    optimizer = optimizer_adam(lr = 0.001, beta_1 = 0.9, beta_2 = 0.999,
                               epsilon = NULL, decay = 0, amsgrad = FALSE, clipnorm = NULL,
                               clipvalue = NULL),
    metrics = list("mean_absolute_error")
  )
  model
}

model <- build_model()
model %>% summary()

print_dot_callback <- callback_lambda(
  on_epoch_end = function(epoch, logs) {
    if (epoch %% 50 == 0) cat("\n")
    cat(".")
  }
)

epochs <- 100

history <- model %>% fit(
  train_data, # Only runs when train_data is a matrix object
  train_label,
  epochs = epochs,
  batch_size = 100,
  validation_split = 0.2,
  verbose = 0,
  callbacks = list(print_dot_callback)
)

plot(x = c(1:length(history$metrics$mean_absolute_error)), y = history$metrics$mean_absolute_error, smooth = FALSE,
     xlab ="Index")

early_stop <- callback_early_stopping(monitor = "val_loss", patience = 20)


model <- build_model()
history <- model %>% fit(
  train_data,
  train_label,
  epochs = epochs,
  validation_split = 0.2,
  verbose = 0,
  callbacks = list(early_stop, print_dot_callback)
)


plot(x = c(1:length(history$metrics$mean_absolute_error)), y = history$metrics$mean_absolute_error, smooth = FALSE,
     xlab = "Index")


## Plot: Actual Price vs. Predicted Price ##

test_predictions <- model %>% predict(test_data)
score.vs.actual <- cbind(test_predictions, test_label) %>% as.data.frame()
colnames(score.vs.actual) <- c("test_predictions", "test_label")

ggplot(score.vs.actual, aes(x = c(1:length(test_label)))) + 
  geom_line(aes(y = test_label, color = "actual")) + 
  geom_line(aes(y = test_predictions, color = "prediction")) +
  scale_x_log10() +
  labs(x = "Index of Observations", 
       y = "Price of Each Trade",
       title = "Neural Network Model: Actual Price vs. Predicted Price",
       subtitle = "Created by Bond Intelligence Inc") +
  theme(plot.title = element_text(hjust = 0.5, face="bold", color="black", size = 16)) +
  theme(plot.subtitle = element_text(hjust = 0.5, size = 10))

  ## R squared value, root squared mean error, and mean absolute error of the neural network model ##

  data.frame(R2 = R2(test_predictions, test_label),
           RMSE = RMSE(test_predictions, test_label),
           MAE = MAE(test_predictions, test_label))


# Comparing regression model prediction and neural network model predictions on a single bond #

# Regression model predictions for bond "046617BZ8":
Aa <- filter(Reg_data, CUSIP == "046617BZ8") %>%
  select(Dollar.Price.of.the.trade) %>%
  unlist() %>%
  sprintf(fmt = "%.2f") %>%
  as.numeric()

Ss <- predict(reg_dollar.price, filter(Reg_data, CUSIP == "046617BZ8")) %>% as.numeric()

SVA <- cbind(Ss, Aa) %>% as.data.frame()
colnames(SVA) <- c("predictions", "labels")

ggplot(SVA, aes(x = c(1:length(labels)))) + 
  geom_line(aes(y = labels, color = "actual")) + 
  geom_line(aes(y = predictions, color = "prediction")) +
  lims(y = c(99,102.5)) +
  labs(x = "Index of Observations", 
       y = "Price of Each Trade",
       title = "Regression Model: Actual Price vs. Predicted Price for Bond '046617BZ8'",
       subtitle = "Created by Bond Intelligence Inc") +
  theme(plot.title = element_text(hjust = 0.5, face="bold", color="black", size = 12)) +
  theme(plot.subtitle = element_text(hjust = 0.5, size = 8))

  