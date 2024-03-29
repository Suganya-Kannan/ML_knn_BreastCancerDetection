## ------------------k Nearest Neighbours kNN algorithm-----------------

cancerData <- read.csv("D:/Way to go as DS/ML/Data/cancer.csv", header = T, stringsAsFactors = F)
str(cancerData)
colnames(cancerData)
cancerData <- cancerData[-1] ## removed id
table(cancerData$diagnosis)
cancerData$diagnosis <- factor(cancerData$diagnosis, levels = c("B", "M"),
                               labels = c("Benign", "Malignant"))
table(cancerData$diagnosis)
round(prop.table(table(cancerData$diagnosis)) * 100, digits = 1)

normalize <- function(x){(x - min(x))/ (max(x)-min(x))} 
save(normalize, file = "normalizeFun.R")

## or normalize <- function(x) {return ((x - min(x)) / (max(x) - min(x)))}
normalize(cancerData$radius_mean)           
cancerDataNew <- as.data.frame(lapply(cancerData[2:31], normalize)) ## removing the diagnois factor
head(cancerDataNew)
summary(cancerDataNew$area_mean)
normalize(c(1, 2, 3, 4, 5))

## Training the model

install.packages("class")
library(class)

## Splitting data 

## 75% of the sample size
##smp_size <- floor(0.75 * nrow(cancerDataNew))

## set the seed to make your partition reproducible

##set.seed(123)
##train_ind <- sample(seq_len(nrow(cancerDataNew)), size = smp_size)

##train <- cancerDataNew[train_ind, ]
##test <- cancerDataNew[-train_ind, ]

trainData <- cancerDataNew[1:469,]
testData <- cancerDataNew[470:569,]
train_labels <- cancerData[1:469, 1]
test_labels <- cancerData[470:569, 1]


## TRaining a model on data
View(trainData)
predictedModel <- knn(train =trainData, test = testData, cl = train_labels, k=21)
predictedModel
table(predictedModel)
table(cancerData$diagnosis)
prop.table(table(predictedModel))
prop.table(table(cancerData$diagnosis))
library(gmodels) ## for crosstable()

## evaluating model performance

CrossTable(x=test_labels, y=predictedModel, prop.chisq = F)


## improving model performance using z-satndardization


cancerDataZ <- as.data.frame(scale(cancerData[-1]))
summary(cancerDataZ$area_mean)
View(cancerDataZ)
traindataZ <- cancerDataZ[1:469,]
testdataZ <- cancerDataZ[470:569,]
train_labelsZ <- cancerData[1:469,1]
test_labelsZ <- cancerData[470:569,1]

testPredictionZ <- knn(train = traindataZ, test = testdataZ, cl = train_labelsZ, k=21)
CrossTable(testPredictionZ, test_labelsZ, prop.chisq = F, chisq = T)
