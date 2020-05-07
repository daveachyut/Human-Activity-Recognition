install.packages('corrplot')
install.packages('rquery')

library('tidyverse')
library('dplyr')
library('ggplot2')
library('lolcat')
library('corrplot')
library('rquery')
library('RColorBrewer')
library('Cairo')
library('cairoDevice')
library('e1071')
library('knitr')
library('caret')
library('scatterplot3d')
library('glmnet')
library('MASS')
library('nnet')
library('neuralnet')

tibble(HAR_train)

names_train=colnames(HAR_train)

HAR_train_1 <- data.frame(matrix(as.numeric(unlist(HAR_train[,1:562])), ncol=562, byrow=F),stringsAsFactors=FALSE)

HAR_train_1$Activity<-HAR_train$Activity

colnames(HAR_train_1)<-names_train

HAR_train_1$Activity

names_test=colnames(HAR_test)

HAR_test_1 <- data.frame(matrix(as.numeric(unlist(HAR_test[,1:562])), ncol=562, byrow=F),stringsAsFactors=FALSE)

HAR_test_1$Activity<-HAR_test$Activity

colnames(HAR_test_1)<-names_test

#HAR_train[,1]

Lay_Train=HAR_train_1[HAR_train_1$Activity=='LAYING', ]
Sit_Train=HAR_train_1[HAR_train_1$Activity=='SITTING', ]
Stand_Train=HAR_train_1[HAR_train_1$Activity=='STANDING', ]
Walk_Train=HAR_train_1[HAR_train_1$Activity=='WALKING', ]
Walk_Up_Train=HAR_train_1[HAR_train_1$Activity=='WALKING_UPSTAIRS', ]
Walk_Down_Train=HAR_train_1[HAR_train_1$Activity=='WALKING_DOWNSTAIRS', ]


#####################
##    Question 1
#####################





hist(Lay_Train$tBodyAccmeanX,
     main="Laying X", 
     xlab="tBodyAccmeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(Lay_Train$tBodyAccmeanY,
     main="Laying Y", 
     xlab="tBodyAccmeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(Lay_Train$tBodyAccmeanZ,
     main="Laying Z", 
     xlab="tBodyAccmeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(Walk_Up_Train$tBodyAccmeanX,
     main="Walking Upstairs X", 
     xlab="tBodyAccmeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(Walk_Up_Train$tBodyAccmeanY,
     main="Walking Upstairs Y", 
     xlab="tBodyAccmeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(Walk_Up_Train$tBodyAccmeanZ,
     main="Walking Upstairs Z", 
     xlab="tBodyAccmeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)


#####################
##    Question 2
#####################





hist(Lay_Train$tBodyGyromeanX,
     main="Laying X", 
     xlab="tBodyGyromeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(Lay_Train$tBodyGyromeanY,
     main="Laying Y", 
     xlab="tBodyGyromeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(Lay_Train$tBodyGyromeanZ,
     main="Laying Z", 
     xlab="tBodyGyromeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(Walk_Up_Train$tBodyGyromeanX,
     main="Walking Upstairs X", 
     xlab="tBodyGyromeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(Walk_Up_Train$tBodyGyromeanY,
     main="Walking Upstairs Y", 
     xlab="tBodyGyromeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(Walk_Up_Train$tBodyGyromeanZ,
     main="Walking Upstairs Z", 
     xlab="tBodyGyromeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)


#####################
##    Question 3
#####################





Matrix_train=matrix(as.numeric(unlist(HAR_train_1[,2:562])), ncol=561, byrow=F)

Cor_Matrix_train=cor(Matrix_train, method = "pearson")

col1=colorRampPalette(c('#00007F', 'blue', '#007FFF', 'cyan', 'white', 'yellow','#FF7F00', 'red', '#7F0000'))

corrplot(corr = Cor_Matrix_train, method = 'color', l1.pos = 561, col = col1(100))


#####################
##    Question 4
#####################







Nfolds = 3
the_samples=matrix(as.numeric(unlist(HAR_train_1[,2:562])), ncol=561, byrow=F)
typeof(the_samples)

#print(HAR_train_1$Activity)
#print(as.factor(HAR_train_1$Activity))
#print(as.numeric(as.factor(HAR_train_1$Activity)))

c=as.numeric(as.factor(HAR_train_1$Activity))
foldIndex <- sample(1:Nfolds,size=7352,prob=rep(1,Nfolds)/Nfolds,replace=TRUE)

## discretize the values of the cost parameter: M values from 0.05 to 10

M = 5;
regul <- seq(10,90,length.out=M)      # values of the regularization parameter
the_risk <- rep(0,M)                    # values of the error
risk_1 <- c()
predict_class=list()

for (k in 1:M) {                        # for all values of the regularization parameter
        
        print(k)                            # to track progress
        
        for (fold_i in 1:Nfolds) {                    # for every fold
                        
                train.x <- the_samples[foldIndex!=fold_i,] # exclude the fold from the training data
                typeof(the_samples)

                train.c <- c[foldIndex!=fold_i]
                typeof(train.x)
                        
                test.x <- the_samples[foldIndex==fold_i,] # the fold is the test data
                test.c <- c[foldIndex==fold_i]
                        
                ## train the SVM with the training data
                        
                the_data = data.frame(varY = train.c, varX = train.x);
                typeof(the_data)
                        
                set.seed(120917)
                model = svm(formula=varY ~., data = the_data,  kernel = 'radial', cost = regul[k])
                        
                ## evaluate the performance on the test data
                        
                predict_class = predict(model,data.frame(varX = test.x), rep = 1, all.units = T)
                        
                ## record the error on the test data: sum of the l1 norm of the error between the true class and the predicted class.
                ## we compute the sum of the errors for all the folds
                        
                #print(sum (abs (as.numeric(unlist(predict_class_3)) - test.c), na.rm = T))
                the_risk[k] = the_risk[k] + (sum (abs (as.numeric(unlist(predict_class)) - test.c), na.rm = T)/100)
        }
        print(the_risk[k])
        risk_1=c(risk_1,the_risk[k]/Nfolds)#, na.rm = T 
}

risk_1=risk_1/(M*20)
print(risk_1)
## optimal C is given by the minimum of the prediction on the test data

regulOpt = which.min(risk_1)
print(regulOpt)

plot(regul,risk_1, type = 'l', col='red', xlab='lambda', ylab='residual sum of squares')

print('Optimal lambda value is ')
print(regul[regulOpt])


###############################################################################


Nfolds_1 = 5
the_samples_1=matrix(as.numeric(unlist(HAR_train_1[,2:7])), ncol=6, byrow=F)
typeof(the_samples_1)

#print(HAR_train_1$Activity)
#print(as.factor(HAR_train_1$Activity))
#print(as.numeric(as.factor(HAR_train_1$Activity)))

c_1=as.numeric(as.factor(HAR_train_1$Activity))
foldIndex_1 <- sample(1:Nfolds_1,size=7352,prob=rep(1,Nfolds_1)/Nfolds_1,replace=TRUE)

## discretize the values of the cost parameter: M values from 0.05 to 10

M_1 = 50;
regul_1 <- seq(2,102,length.out=M_1)      # values of the regularization parameter
the_risk_1 <- rep(0,M_1)                    # values of the error
risk_2 <- c()
predict_class_1=list()

for (k_1 in 1:M_1) {                        # for all values of the regularization parameter
        
        print(k_1)                            # to track progress

        for (fold_i_1 in 1:Nfolds_1) {                    # for every fold
                
                train.x_1 <- the_samples_1[foldIndex_1!=fold_i_1,] # exclude the fold from the training data
                typeof(the_samples_1)
                
                train.c_1 <- c_1[foldIndex_1!=fold_i_1]
                typeof(train.x_1)
                
                test.x_1 <- the_samples_1[foldIndex_1==fold_i_1,] # the fold is the test data
                test.c_1 <- c_1[foldIndex_1==fold_i_1]
                
                ## train the SVM with the training data
                
                the_data_1 = data.frame(varY_1 = train.c_1, varX_1 = train.x_1);
                typeof(the_data_1)
                
                set.seed(120917)
                model_1 = svm(formula=varY_1 ~., data = the_data_1,  kernel = 'radial', cost = regul_1[k])
                
                ## evaluate the performance on the test data
                
                predict_class_1 = predict(model_1,data.frame(varX_1 = test.x_1), rep = 1, all.units = T)
                
                ## record the error on the test data: sum of the l1 norm of the error between the true class and the predicted class.
                ## we compute the sum of the errors for all the folds
                
                #print(sum (abs (as.numeric(unlist(predict_class_3)) - test.c), na.rm = T))
                the_risk_1[k_1] = the_risk_1[k_1] + (sum (abs (as.numeric(unlist(predict_class_1)) - test.c_1), na.rm = T)/100)
        }
        print(the_risk_1[k_1])
        risk_2=c(risk_2,the_risk_1[k_1]/Nfolds_1)#, na.rm = T 
}

risk_2=risk_2/(M_1)
print(risk_2)
## optimal C is given by the minimum of the prediction on the test data

regulOpt_1 = which.min(risk_2)
print(regulOpt_1)

plot(regul_1,risk_2, type = 'l', col='red', xlab='lambda', ylab='residual sum of squares')

print('Optimal lambda value is ')
print(regul_1[regulOpt_1])


#####################
##    Question 5
#####################







Nfolds_2 = 3
the_samples_2=matrix(as.numeric(unlist(HAR_train_1[,2:562])), ncol=561, byrow=F)
typeof(the_samples_2)

#print(HAR_train_1$Activity)
#print(as.factor(HAR_train_1$Activity))
#print(as.numeric(as.factor(HAR_train_1$Activity)))

c_2=as.numeric(as.factor(HAR_train_1$Activity))
foldIndex_2 <- sample(1:Nfolds_2,size=7352,prob=rep(1,Nfolds_2)/Nfolds_2,replace=TRUE)

## discretize the values of the cost parameter: M values from 0.05 to 10

predict_class_2=list()

for (fold_i_2 in 1:Nfolds_2) {                    # for every fold
                
        train.x_2 <- the_samples_2[foldIndex_2!=fold_i_2,] # exclude the fold from the training data
        typeof(the_samples_2)
                
        train.c_2 <- c_2[foldIndex_2!=fold_i_2]
        typeof(train.x_2)
                
        test.x_2 <- the_samples_2[foldIndex_2==fold_i_2,] # the fold is the test data
        test.c_2 <- c_2[foldIndex_2==fold_i_2]
                
        ## train the SVM with the training data
                
        the_data_2 = data.frame(varY = train.c_2, varX = train.x_2);
        typeof(the_data_2)
                
        set.seed(120917)
        model_2 = svm(formula=varY ~., data = the_data_2,  kernel = 'radial', cost = 10)
                
        ## evaluate the performance on the test data
                
        predict_class_2 = predict(model_2,data.frame(varX = test.x_2), rep = 1, all.units = T)
                
        ## record the error on the test data: sum of the l1 norm of the error between the true class and the predicted class.
        ## we compute the sum of the errors for all the folds
                
        #print(sum (abs (as.numeric(unlist(predict_class_3)) - test.c), na.rm = T))

        #the_risk[k] = the_risk[k] + (sum (abs (as.numeric(unlist(predict_class)) - test.c), na.rm = T)/100)
}

predict_class_2=round(predict_class_2,0)

confusion.matrix(actual = test.c_2, predicted = predict_class_2)

##################################################################

accuracy=mean(predict_class_2==test.c_2)*100

predict_class_2<-factor(predict_class_2, levels = c(1,2,3,4,5,6))
test.c_2<-factor(test.c_2)

Confuse=kable(confusionMatrix(data = test.c_2, reference = predict_class_2)$table)
Confuse

print(typeof(predict_class_2))

#####################
##    Question 6
#####################








mis_sta=37/(478+393+427+37)
mis_non_sta=52/(413+316+340+52)

mis_lay=0
mis_sit=17/410
mis_stand=20/447
mis_walk=14/427
mis_walk_down=37/353
mis_walk_up=1/341

#####################
##    Question 7
#####################






a_t=data.frame(HAR_train_1$tBodyAccmeanX,HAR_train_1$tBodyAccmeanY,HAR_train_1$tBodyAccmeanZ,c_2)

s3d<-scatterplot3d(x = a_t$HAR_train_1.tBodyAccmeanX, y = a_t$HAR_train_1.tBodyAccmeanY, z = a_t$HAR_train_1.tBodyAccmeanZ, box = F, xlab = 'tBodyAccmeanX', ylab = 'tBodyAccmeanX', zlab = 'tBodyAccmeanX')
legend(s3d$xyz.convert(0.5, 0.67, 0.5), legend = 'all_data',
       col =  c("#000000"), pch = 16)

colors <- c("#66CC00", "#0066CC")

static=rep(1,7352)
for (m in 1:7352)
{
        if (a_t$c_2[m]>3)
        {
                static[m]=static[m]+1
        }
}

colors<-colors[static]

s3d_1<-scatterplot3d(x = a_t$HAR_train_1.tBodyAccmeanX, y = a_t$HAR_train_1.tBodyAccmeanY, z = a_t$HAR_train_1.tBodyAccmeanZ, color = colors, box = F, xlab = 'tBodyAccmeanX', ylab = 'tBodyAccmeanX', zlab = 'tBodyAccmeanX')
legend(s3d_1$xyz.convert(0.5, 0.67, 0.5), legend = c('static', 'non static'),
       col =  c("#66CC00", "#0066CC"), pch = 16)

colors_1 <- c("#66CC00","#000000", "#FF6600", "#00FFFF","#9933FF", "#CC6699")

colors_1<-colors_1[a_t$c_2]

s3d_2<-scatterplot3d(x = a_t$HAR_train_1.tBodyAccmeanX, y = a_t$HAR_train_1.tBodyAccmeanY, z = a_t$HAR_train_1.tBodyAccmeanZ, color = colors_1, box = F, xlab = 'tBodyAccmeanX', ylab = 'tBodyAccmeanX', zlab = 'tBodyAccmeanX')
legend(s3d_1$xyz.convert(0.5, 0.67, 0.5), legend = c('laying', 'sitting','standing', 'walking','walking up', 'walking down'),
       col =  c("#66CC00","#000000", "#FF6600", "#00FFFF","#9933FF", "#CC6699"), pch = 16)

#####################
##    Question 8
#####################






a_t_sta=a_t[a_t$c_2<=3, ]

a_t_non_sta=a_t[a_t$c_2>3, ]

hist(a_t_sta$HAR_train_1.tBodyAccmeanX,
     main="Static X", 
     xlab="tBodyAccmeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_sta$HAR_train_1.tBodyAccmeanY,
     main="Static Y", 
     xlab="tBodyAccmeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_sta$HAR_train_1.tBodyAccmeanZ,
     main="Static Z", 
     xlab="tBodyAccmeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(a_t_sta[1:3])

hist(a_t_non_sta$HAR_train_1.tBodyAccmeanX,
     main="Non Static X", 
     xlab="tBodyAccmeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_non_sta$HAR_train_1.tBodyAccmeanY,
     main="Non Static Y", 
     xlab="tBodyAccmeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_non_sta$HAR_train_1.tBodyAccmeanZ,
     main="Non Static Z", 
     xlab="tBodyAccmeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(a_t_non_sta[1:3])

#####################
##    Question 9
#####################






g_t=data.frame(HAR_train_1$tBodyGyromeanX,HAR_train_1$tBodyGyromeanY,HAR_train_1$tBodyGyromeanZ,c_2)

s3d_3<-scatterplot3d(x = g_t$HAR_train_1.tBodyGyromeanX, y = g_t$HAR_train_1.tBodyGyromeanY, z = g_t$HAR_train_1.tBodyGyromeanZ, box = F, xlab = 'tBodyGyromeanX', ylab = 'tBodyGyromeanX', zlab = 'tBodyGyromeanX')
legend(s3d_3$xyz.convert(0.5, 0.67, 0.5), legend = 'all_data',
       col =  c("#000000"), pch = 16)

colors_2 <- c("#66CC00", "#0066CC")

static_1=rep(1,7352)
for (m in 1:7352)
{
        if (g_t$c_2[m]>3)
        {
                static_1[m]=static_1[m]+1
        }
}

colors_2<-colors_2[static_1]

s3d_4<-scatterplot3d(x = g_t$HAR_train_1.tBodyGyromeanX, y = g_t$HAR_train_1.tBodyGyromeanY, z = g_t$HAR_train_1.tBodyGyromeanZ, color = colors_2, box = F, xlab = 'tBodyGyromeanX', ylab = 'tBodyGyromeanX', zlab = 'tBodyGyromeanX')
legend(s3d_4$xyz.convert(0.5, 0.67, 0.5), legend = c('static', 'non static'),
       col =  c("#66CC00", "#0066CC"), pch = 16)

colors_3 <- c("#66CC00","#000000", "#FF6600", "#00FFFF","#9933FF", "#CC6699")

colors_3<-colors_3[g_t$c_2]

s3d_5<-scatterplot3d(x = g_t$HAR_train_1.tBodyGyromeanX, y = g_t$HAR_train_1.tBodyGyromeanY, z = g_t$HAR_train_1.tBodyGyromeanZ, color = colors_3, box = F, xlab = 'tBodyGyromeanX', ylab = 'tBodyGyromeanX', zlab = 'tBodyGyromeanX')
legend(s3d_5$xyz.convert(0.5, 0.67, 0.5), legend = c('laying', 'sitting','standing', 'walking','walking up', 'walking down'),
       col =  c("#66CC00","#000000", "#FF6600", "#00FFFF","#9933FF", "#CC6699"), pch = 16)

#####################
##    Question 10
#####################






g_t_stand=g_t[g_t$c_2==3, ]

g_t_sit=g_t[g_t$c_2==2, ]

g_t_lay=g_t[g_t$c_2==1, ]

g_t_walk=g_t[g_t$c_2==4, ]

g_t_walk_down=g_t[g_t$c_2==5, ]

g_t_walk_up=g_t[g_t$c_2==6, ]

hist(g_t_stand$HAR_train_1.tBodyGyromeanX,
     main="Stand X", 
     xlab="tBodyGyromeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_stand$HAR_train_1.tBodyGyromeanY,
     main="Stand Y", 
     xlab="tBodyGyromeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_stand$HAR_train_1.tBodyGyromeanZ,
     main="Stand Z", 
     xlab="tBodyGyromeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(g_t_stand[1:3])

hist(g_t_sit$HAR_train_1.tBodyGyromeanX,
     main="Sit X", 
     xlab="tBodyGyromeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_sit$HAR_train_1.tBodyGyromeanY,
     main="Sit Y", 
     xlab="tBodyGyromeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_sit$HAR_train_1.tBodyGyromeanZ,
     main="Sit Z", 
     xlab="tBodyGyromeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(g_t_sit[1:3])

hist(g_t_lay$HAR_train_1.tBodyGyromeanX,
     main="Lay X", 
     xlab="tBodyGyromeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_lay$HAR_train_1.tBodyGyromeanY,
     main="Lay X", 
     xlab="tBodyGyromeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_lay$HAR_train_1.tBodyGyromeanZ,
     main="Lay X", 
     xlab="tBodyGyromeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(g_t_lay[1:3])

hist(g_t_walk$HAR_train_1.tBodyGyromeanX,
     main="Walk X", 
     xlab="tBodyGyromeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_walk$HAR_train_1.tBodyGyromeanY,
     main="Walk Y", 
     xlab="tBodyGyromeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_walk$HAR_train_1.tBodyGyromeanZ,
     main="Walk Z", 
     xlab="tBodyGyromeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(g_t_walk[1:3])

hist(g_t_walk_down$HAR_train_1.tBodyGyromeanX,
     main="Walk Down X", 
     xlab="tBodyGyromeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_walk_down$HAR_train_1.tBodyGyromeanY,
     main="Walk Down Y", 
     xlab="tBodyGyromeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_walk_down$HAR_train_1.tBodyGyromeanZ,
     main="Walk Down Z", 
     xlab="tBodyGyromeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(g_t_walk_down[1:3])

hist(g_t_walk_up$HAR_train_1.tBodyGyromeanX,
     main="Walk Up X", 
     xlab="g_t_walk_up$HAR_train_1.tBodyGyromeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_walk_up$HAR_train_1.tBodyGyromeanY,
     main="Walk Up Y", 
     xlab="g_t_walk_up$HAR_train_1.tBodyGyromeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_walk_up$HAR_train_1.tBodyGyromeanZ,
     main="Walk Up Z", 
     xlab="g_t_walk_up$HAR_train_1.tBodyGyromeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(g_t_walk_up[1:3])

############################################################################################################################################

#####################
##    Question 10
#####################






pc_walk_up.mat=matrix(as.numeric(unlist(Walk_Up_Train[,2:562])), ncol=561, byrow=F)

pc_walk_up=prcomp(x = pc_walk_up.mat, center = T, scale. = F)

typeof(pc_walk_up)

print(pc_walk_up$sdev)

plot(c(1:561), pc_walk_up$sdev)

print(pc_walk_up$rotation)

plot(pc_walk_up$rotation)

print(pc_walk_up$center)

plot(c(1:561), pc_walk_up$center)

print(pc_walk_up$scale)

print(pc_walk_up$x)

plot(pc_walk_up$x)

pc_walk_up.var=(pc_walk_up$sdev)^2

pc_walk_up.pvar=pc.var/sum(pc_walk_up.var)

pc_walk_up.resvar=1-cumsum(pc_walk_up.pvar)

s3d_6<-scatterplot3d(x = pc_walk_up$x[,1], y = pc_walk_up$x[,2], z = pc_walk_up$x[,3], box=F, xlab = 'PC1', ylab = 'PC2', zlab = 'PC3')
legend(s3d_6$xyz.convert(2, 2.67, 2), legend = 'Walk_Up',
       col =  c("#000000"), pch = 16)

#####################
##    Question 11
#####################






target_walk_up=sum(pc_walk_up.resvar[1:100]) * 0.9

sum_resvar_walk_up=0
count_resvar_walk_up=1
while (sum_resvar_walk_up < target_walk_up)
{
        sum_resvar_walk_up = sum_resvar_walk_up + pc_walk_up.resvar[count_resvar_walk_up]
        count_resvar_walk_up = count_resvar_walk_up + 1
}
cross_walk_up = count_resvar_walk_up

plot(pc_walk_up.resvar[1:100], xlim=c(1,100), ylim=c(0,1), xlab='Number of Principal Components', ylab='percentage of residual variance', type='b', col='red', main = 'Walk Up')
abline(v=cross_walk_up)
abline(h=pc_walk_up.resvar[cross_walk_up])

#####################
##    Question 12
#####################






pc_lay=prcomp(x = matrix(as.numeric(unlist(Lay_Train[,2:562])), ncol=561, byrow=F), center = T, scale. = F)

typeof(pc_lay)

print(pc_lay$sdev)

plot(c(1:561), pc_lay$sdev)

pc_lay.var=(pc_lay$sdev)^2

pc_lay.pvar=pc.var/sum(pc_lay.var)

pc_lay.resvar=1-cumsum(pc_lay.pvar)

s3d_7<-scatterplot3d(x = pc_lay$x[,1], y = pc_lay$x[,2], z = pc_lay$x[,3], box=F, xlab = 'PC1', ylab = 'PC2', zlab = 'PC3')
legend(s3d_7$xyz.convert(4, 5.34, 4), legend = 'Lay',
       col =  c("#000000"), pch = 16)


target_lay=sum(pc_lay.resvar[1:100]) * 0.9

sum_resvar_lay=0
count_resvar_lay=1
while (sum_resvar_lay < target_lay)
{
        sum_resvar_lay = sum_resvar_lay + pc_lay.resvar[count_resvar_lay]
        count_resvar_lay = count_resvar_lay + 1
}
cross_lay = count_resvar_lay

plot(pc_lay.resvar[1:100], xlim=c(1,100), ylim=c(0,1), xlab='Number of Principal Components', ylab='percentage of residual variance', type='b', col='red', main='Lay')
abline(v=cross_lay)
abline(h=pc_lay.resvar[cross_lay])

#####################
##    Question 13
#####################






pc_HAR_train=prcomp(x = matrix(as.numeric(unlist(HAR_train_1[,2:562])), ncol=561, byrow=F), center = T, scale. = F)

typeof(pc_HAR_train)

print(pc_HAR_train$sdev)

plot(c(1:561), pc_HAR_train$sdev)

pc_HAR_train.var=(pc_HAR_train$sdev)^2

pc_HAR_train.pvar=pc_HAR_train.var/sum(pc_HAR_train.var)

pc_HAR_train.resvar=1-cumsum(pc_HAR_train.pvar)

Couleur=c('cornflowerblue', 'gold', 'gray80', 'lightpink', 'midnightblue', 'springgreen4')

Couleur = Couleur[c_2]

s3d_8<-scatterplot3d(x = pc_HAR_train$x[,1], y = pc_HAR_train$x[,2], z = pc_HAR_train$x[,3], box=F, xlab = 'PC1', ylab = 'PC2', zlab = 'PC3', color = Couleur)
legend(s3d_8$xyz.convert(5, 6.67, 5), legend = c('Laying', 'Standing', 'Sitting', 'Walking', 'Walking_Upstairs', 'Walking_Downstairs'),
       col =  c('cornflowerblue', 'gold', 'gray80', 'lightpink', 'midnightblue', 'springgreen4'), pch = 16)

#####################
##    Question 14
#####################






target_HAR_train=sum(pc_HAR_train.resvar[1:100]) * 0.9

sum_resvar_HAR_train=0
count_resvar_HAR_train=1
while (sum_resvar_HAR_train < target_HAR_train)
{
        sum_resvar_HAR_train = sum_resvar_HAR_train + pc_HAR_train.resvar[count_resvar_HAR_train]
        count_resvar_HAR_train = count_resvar_HAR_train + 1
}
cross_HAR_train = count_resvar_HAR_train

plot(pc_HAR_train.resvar[1:100], xlim=c(1,100), ylim=c(0,1), xlab='Number of Principal Components', ylab='percentage of residual variance', type='b', col='red')
abline(v=cross_HAR_train)
abline(h=pc_HAR_train.resvar[cross_HAR_train])

#####################
##    Question 15
#####################






print('The scatterplot after PCA differs in two aspects:')
      
print('1. the data corresponding to each group is clustered better within the cluster.')
      
print('2. Due to this differentiating between clusters is easier.')

#####################
##    Question 16
#####################






HAR_train.mat=matrix(as.numeric(unlist(HAR_train_1[,2:562])), ncol=561, byrow=F)

pc_HAR_train=prcomp(x = HAR_train.mat, center = T, scale. = T)

HAR_test.mat=matrix(as.numeric(unlist(HAR_test_1[,2:562])), ncol=561, byrow=F)

Accuracy = c()

#################### k = 30 ####################

k_1 = 30

HAR_train_2_1 = data.frame(pc_HAR_train$x[,1:k_1])

HAR_test_2_1 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_1 = as.data.frame(HAR_test_2_1[,1:k_1])

myglm_1 = cv.glmnet(as.matrix(HAR_train_2_1), c_2, alpha = 1, family = 'multinomial')

ypredstr_1 = predict(myglm_1, newx = as.matrix(HAR_test_2_1), s = 'lambda.min', type = 'class')

c_3 = as.numeric(as.factor(HAR_test_1$Activity))

accuracy_1=mean(ypredstr_1==c_3)*100
accuracy_1

Accuracy = c(Accuracy, accuracy_1)

Confuse_1=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(ypredstr_1))$table)
Confuse_1

#################### k = 40 ####################

k_2 = 40

HAR_train_2_2 = data.frame(pc_HAR_train$x[,1:k_2])

HAR_test_2_2 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_2 = as.data.frame(HAR_test_2_2[,1:k_2])

myglm_2 = cv.glmnet(as.matrix(HAR_train_2_2), c_2, alpha = 1, family = 'multinomial')

ypredstr_2 = predict(myglm_2, newx = as.matrix(HAR_test_2_2), s = 'lambda.min', type = 'class')

accuracy_2=mean(ypredstr_2==c_3)*100
accuracy_2

Accuracy = c(Accuracy, accuracy_2)

Confuse_2=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(ypredstr_2))$table)
Confuse_2

#################### k = 50 ####################

k_3 = 50

HAR_train_2_3 = data.frame(pc_HAR_train$x[,1:k_3])

HAR_test_2_3 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_3 = as.data.frame(HAR_test_2_3[,1:k_3])

myglm_3 = cv.glmnet(as.matrix(HAR_train_2_3), c_2, alpha = 1, family = 'multinomial')

ypredstr_3 = predict(myglm_3, newx = as.matrix(HAR_test_2_3), s = 'lambda.min', type = 'class')

accuracy_3=mean(ypredstr_3==c_3)*100
accuracy_3

Accuracy = c(Accuracy, accuracy_3)

Confuse_3=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(ypredstr_3))$table)
Confuse_3

#################### k = 60 ####################

k_4 = 60

HAR_train_2_4 = data.frame(pc_HAR_train$x[,1:k_4])

HAR_test_2_4 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_4 = as.data.frame(HAR_test_2_4[,1:k_4])

myglm_4 = cv.glmnet(as.matrix(HAR_train_2_4), c_2, alpha = 1, family = 'multinomial')

ypredstr_4 = predict(myglm_4, newx = as.matrix(HAR_test_2_4), s = 'lambda.min', type = 'class')

accuracy_4=mean(ypredstr_4==c_3)*100
accuracy_4

Accuracy = c(Accuracy, accuracy_4)

Confuse_4=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(ypredstr_4))$table)
Confuse_4

#################### k = 70 ####################

k_5 = 70

HAR_train_2_5 = data.frame(pc_HAR_train$x[,1:k_5])

HAR_test_2_5 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_5 = as.data.frame(HAR_test_2_5[,1:k_5])

myglm_5 = cv.glmnet(as.matrix(HAR_train_2_5), c_2, alpha = 1, family = 'multinomial')

ypredstr_5 = predict(myglm_5, newx = as.matrix(HAR_test_2_5), s = 'lambda.min', type = 'class')

accuracy_5=mean(ypredstr_5==c_3)*100
accuracy_5

Accuracy = c(Accuracy, accuracy_5)

Confuse_5=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(ypredstr_5))$table)
Confuse_5

#################### k = 20 ####################

k_6 = 20

HAR_train_2_6 = data.frame(pc_HAR_train$x[,1:k_6])

HAR_test_2_6 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_6 = as.data.frame(HAR_test_2_6[,1:k_6])

myglm_6 = cv.glmnet(as.matrix(HAR_train_2_6), c_2, alpha = 1, family = 'multinomial')

ypredstr_6 = predict(myglm_6, newx = as.matrix(HAR_test_2_6), s = 'lambda.min', type = 'class')

accuracy_6 = mean(ypredstr_6==c_3)*100
accuracy_6

Accuracy = c(accuracy_6, Accuracy)

Confuse_6 = kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(ypredstr_6))$table)
Confuse_6

#################### Plot ######################

plot(c(20,30,40,50,60,70), Accuracy, xlab='Number of Principal Components', ylab='Accuracy', type = 'b', main="Logistic Regression")

#####################
##    Question 18
#####################






HAR_train.mat=matrix(as.numeric(unlist(HAR_train_1[,2:562])), ncol=561, byrow=F)

pc_HAR_train=prcomp(x = HAR_train.mat, center = T, scale. = T)

HAR_test.mat=matrix(as.numeric(unlist(HAR_test_1[,2:562])), ncol=561, byrow=F)

theClass <- as.factor(c_2)                 # load the color as factor

c_3 = as.numeric(as.factor(HAR_test_1$Activity))

Accuracy_1 = c()

#################### k = 30 ####################

k_1 = 30

HAR_train_2_1 = data.frame(pc_HAR_train$x[,1:k_1])

HAR_test_2_1 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_1 = as.data.frame(HAR_test_2_1[,1:k_1])

## QDA

qda_1 = qda(as.matrix(HAR_train_2_1), theClass)                       # perform quadratic discriminant analysis

## use the trained classifier to predict the labels at equally spaces locations on the grid tst_grid the class label is
## in Z$class, but we do not use it, rather, we use the posterior probability P(class = k| X-x) to assess the confidence
## of the label

## validate the classifier on a regular grid 

guess_1 = predict(qda_1, as.matrix(HAR_test_2_1))

accuracy_1=mean(guess_1$class==c_3)*100
accuracy_1

Accuracy_1 = c(Accuracy_1, accuracy_1)

Confuse_1=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(guess_1$class))$table)
Confuse_1

#################### k = 40 ####################

k_2 = 40

HAR_train_2_2 = data.frame(pc_HAR_train$x[,1:k_2])

HAR_test_2_2 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_2 = as.data.frame(HAR_test_2_2[,1:k_2])

## QDA

qda_2 = qda(as.matrix(HAR_train_2_2), theClass)                       # perform quadratic discriminant analysis

## use the trained classifier to predict the labels at equally spaces locations on the grid tst_grid the class label is
## in Z$class, but we do not use it, rather, we use the posterior probability P(class = k| X-x) to assess the confidence
## of the label

## validate the classifier on a regular grid 

guess_2 = predict(qda_2, as.matrix(HAR_test_2_2))

accuracy_2=mean(guess_2$class==c_3)*100
accuracy_2

Accuracy_1 = c(Accuracy_1, accuracy_2)

Confuse_2=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(guess_2$class))$table)
Confuse_2

#################### k = 50 ####################

k_3 = 50

HAR_train_2_3 = data.frame(pc_HAR_train$x[,1:k_3])

HAR_test_2_3 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_3 = as.data.frame(HAR_test_2_3[,1:k_3])

## QDA

qda_3 = qda(as.matrix(HAR_train_2_3), theClass)                       # perform quadratic discriminant analysis

## use the trained classifier to predict the labels at equally spaces locations on the grid tst_grid the class label is
## in Z$class, but we do not use it, rather, we use the posterior probability P(class = k| X-x) to assess the confidence
## of the label

## validate the classifier on a regular grid 

guess_3 = predict(qda_3, as.matrix(HAR_test_2_3))

accuracy_3=mean(guess_3$class==c_3)*100
accuracy_3

Accuracy_1 = c(Accuracy_1, accuracy_3)

Confuse_3=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(guess_3$class))$table)
Confuse_3

#################### k = 60 ####################

k_4 = 60

HAR_train_2_4 = data.frame(pc_HAR_train$x[,1:k_4])

HAR_test_2_4 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_4 = as.data.frame(HAR_test_2_4[,1:k_4])

## QDA

qda_4 = qda(as.matrix(HAR_train_2_4), theClass)                       # perform quadratic discriminant analysis

## use the trained classifier to predict the labels at equally spaces locations on the grid tst_grid the class label is
## in Z$class, but we do not use it, rather, we use the posterior probability P(class = k| X-x) to assess the confidence
## of the label

## validate the classifier on a regular grid 

guess_4 = predict(qda_4, as.matrix(HAR_test_2_4))

accuracy_4=mean(guess_4$class==c_3)*100
accuracy_4

Accuracy_1 = c(Accuracy_1, accuracy_4)

Confuse_4=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(guess_4$class))$table)
Confuse_4

#################### k = 70 ####################

k_5 = 70

HAR_train_2_5 = data.frame(pc_HAR_train$x[,1:k_5])

HAR_test_2_5 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_5 = as.data.frame(HAR_test_2_5[,1:k_5])

## QDA

qda_5 = qda(as.matrix(HAR_train_2_5), theClass)                       # perform quadratic discriminant analysis

## use the trained classifier to predict the labels at equally spaces locations on the grid tst_grid the class label is
## in Z$class, but we do not use it, rather, we use the posterior probability P(class = k| X-x) to assess the confidence
## of the label

## validate the classifier on a regular grid 

guess_5 = predict(qda_5, as.matrix(HAR_test_2_5))

accuracy_5=mean(guess_5$class==c_3)*100
accuracy_5

Accuracy_1 = c(Accuracy_1, accuracy_5)

Confuse_5=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(guess_5$class))$table)
Confuse_5

#################### k = 20 ####################

k_6 = 20

HAR_train_2_6 = data.frame(pc_HAR_train$x[,1:k_6])

HAR_test_2_6 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_6 = as.data.frame(HAR_test_2_6[,1:k_6])

## QDA

qda_6 = qda(as.matrix(HAR_train_2_6), theClass)                       # perform quadratic discriminant analysis

## use the trained classifier to predict the labels at equally spaces locations on the grid tst_grid the class label is
## in Z$class, but we do not use it, rather, we use the posterior probability P(class = k| X-x) to assess the confidence
## of the label

## validate the classifier on a regular grid 

guess_6 = predict(qda_6, as.matrix(HAR_test_2_6))

accuracy_6 = mean(guess_6$class==c_3)*100
accuracy_6

Accuracy_1 = c(accuracy_6, Accuracy_1)

Confuse_6 = kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(guess_6$class))$table)
Confuse_6

#################### Plot ######################

plot(c(20,30,40,50,60,70), Accuracy_1, xlab='Number of Principal Components', ylab='Accuracy', type = 'b', main="Quadratic Discriminant Analysis")

#####################
##    Question 20
#####################






HAR_train.mat=matrix(as.numeric(unlist(HAR_train_1[,2:562])), ncol=561, byrow=F)

pc_HAR_train=prcomp(x = HAR_train.mat, center = T, scale. = T)

HAR_test.mat=matrix(as.numeric(unlist(HAR_test_1[,2:562])), ncol=561, byrow=F)

theClass <- as.factor(c_2)                 # load the color as factor

c_3 = as.numeric(as.factor(HAR_test_1$Activity))

Accuracy_2 = c()

#################### k = 30 ####################

predict_class_1=c()

k_1 = 30

HAR_train_2_1 = data.frame(pc_HAR_train$x[,1:k_1])

HAR_test_2_1 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_1 = as.data.frame(HAR_test_2_1[,1:k_1])

set.seed(120917)
#nn_model_1 = neuralnet(formula=theClass ~ ., data=data.frame(theClass, HAR_train_2_1), hidden=10, stepmax = 2e+05, threshold = 0.64, learningrate = 0.64, err.fct = 'sse', linear.output = FALSE)#

mynn_1 <- nnet(theClass ~ ., data = data.frame(theClass, HAR_train_2_1), size=10, decay=1.0e-2, maxit=2e+05)#, subset = sampidx
## evaluate the performance on the test data

#predict_class_1 = predict(nn_model_1,data.frame(c_3, HAR_test_2_1), rep = 1, all.units = T)
predict_class_1 = predict(mynn_1,data.frame(c_3, HAR_test_2_1), rep = 1, all.units = T)

#X=matrix(unlist(predict_class_1[3]), nrow = 6, byrow = F)
#(post_1=apply(X = X, MARGIN = 2, FUN = which.max))
X_1=matrix(unlist(predict_class_1), nrow = 2947, byrow = F)
(post_1=apply(X = X_1, MARGIN = 1, FUN = which.max))
# Split data
#train_idx <- sample(nrow(iris), 2/3 * nrow(iris))
#iris_train <- iris[train_idx, ]
## record the error on the test data: sum of the l1 norm of the error between the true class and the predicted class.
## we compute the sum of the errors for all the folds

accuracy_1=mean(post_1==c_3)*100
accuracy_1

Accuracy_2 = c(Accuracy_2, accuracy_1)

Confuse_1=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(post_1))$table)
Confuse_1

#################### k = 40 ####################

k_2 = 40

HAR_train_2_2 = data.frame(pc_HAR_train$x[,1:k_2])

HAR_test_2_2 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_2 = as.data.frame(HAR_test_2_2[,1:k_2])

set.seed(120917)
#nn_model_1 = neuralnet(formula=theClass ~ ., data=data.frame(theClass, HAR_train_2_1), hidden=10, stepmax = 2e+05, threshold = 0.64, learningrate = 0.64, err.fct = 'sse', linear.output = FALSE)#

mynn_2 <- nnet(theClass ~ ., data = data.frame(theClass, HAR_train_2_2), size=10, decay=1.0e-2, maxit=2e+05)#, subset = sampidx
## evaluate the performance on the test data

#predict_class_1 = predict(nn_model_1,data.frame(c_3, HAR_test_2_1), rep = 1, all.units = T)
predict_class_2 = predict(mynn_2,data.frame(c_3, HAR_test_2_2), rep = 1, all.units = T)

#X=matrix(unlist(predict_class_1[3]), nrow = 6, byrow = F)
#(post_1=apply(X = X, MARGIN = 2, FUN = which.max))
X_2=matrix(unlist(predict_class_2), nrow = 2947, byrow = F)
(post_2=apply(X = X_2, MARGIN = 1, FUN = which.max))
# Split data
#train_idx <- sample(nrow(iris), 2/3 * nrow(iris))
#iris_train <- iris[train_idx, ]
## record the error on the test data: sum of the l1 norm of the error between the true class and the predicted class.
## we compute the sum of the errors for all the folds

accuracy_2=mean(post_2==c_3)*100
accuracy_2

Accuracy_2 = c(Accuracy_2, accuracy_2)

Confuse_2=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(post_2))$table)
Confuse_2

#################### k = 50 ####################

k_3 = 50

HAR_train_2_3 = data.frame(pc_HAR_train$x[,1:k_3])

HAR_test_2_3 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_3 = as.data.frame(HAR_test_2_3[,1:k_3])

set.seed(120917)
#nn_model_1 = neuralnet(formula=theClass ~ ., data=data.frame(theClass, HAR_train_2_1), hidden=10, stepmax = 2e+05, threshold = 0.64, learningrate = 0.64, err.fct = 'sse', linear.output = FALSE)#

mynn_3 <- nnet(theClass ~ ., data = data.frame(theClass, HAR_train_2_3), size=10, decay=1.0e-2, maxit=2e+05)#, subset = sampidx
## evaluate the performance on the test data

#predict_class_1 = predict(nn_model_1,data.frame(c_3, HAR_test_2_1), rep = 1, all.units = T)
predict_class_3 = predict(mynn_3,data.frame(c_3, HAR_test_2_3), rep = 1, all.units = T)

#X=matrix(unlist(predict_class_1[3]), nrow = 6, byrow = F)
#(post_1=apply(X = X, MARGIN = 2, FUN = which.max))
X_3=matrix(unlist(predict_class_3), nrow = 2947, byrow = F)
(post_3=apply(X = X_3, MARGIN = 1, FUN = which.max))
# Split data
#train_idx <- sample(nrow(iris), 2/3 * nrow(iris))
#iris_train <- iris[train_idx, ]
## record the error on the test data: sum of the l1 norm of the error between the true class and the predicted class.
## we compute the sum of the errors for all the folds

accuracy_3=mean(post_3==c_3)*100
accuracy_3

Accuracy_2 = c(Accuracy_2, accuracy_3)

Confuse_3=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(post_3))$table)
Confuse_3

#################### k = 60 ####################

k_4 = 60

HAR_train_2_4 = data.frame(pc_HAR_train$x[,1:k_4])

HAR_test_2_4 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_4 = as.data.frame(HAR_test_2_4[,1:k_4])

set.seed(120917)
#nn_model_1 = neuralnet(formula=theClass ~ ., data=data.frame(theClass, HAR_train_2_1), hidden=10, stepmax = 2e+05, threshold = 0.64, learningrate = 0.64, err.fct = 'sse', linear.output = FALSE)#

mynn_4 <- nnet(theClass ~ ., data = data.frame(theClass, HAR_train_2_4), size=10, decay=1.0e-2, maxit=2e+05)#, subset = sampidx
## evaluate the performance on the test data

#predict_class_1 = predict(nn_model_1,data.frame(c_3, HAR_test_2_1), rep = 1, all.units = T)
predict_class_4 = predict(mynn_4,data.frame(c_3, HAR_test_2_4), rep = 1, all.units = T)

#X=matrix(unlist(predict_class_1[3]), nrow = 6, byrow = F)
#(post_1=apply(X = X, MARGIN = 2, FUN = which.max))
X_4=matrix(unlist(predict_class_4), nrow = 2947, byrow = F)
(post_4=apply(X = X_4, MARGIN = 1, FUN = which.max))
# Split data
#train_idx <- sample(nrow(iris), 2/3 * nrow(iris))
#iris_train <- iris[train_idx, ]
## record the error on the test data: sum of the l1 norm of the error between the true class and the predicted class.
## we compute the sum of the errors for all the folds

accuracy_4=mean(post_4==c_3)*100
accuracy_4

Accuracy_2 = c(Accuracy_2, accuracy_4)

Confuse_4=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(post_4))$table)
Confuse_4

#################### k = 70 ####################

k_5 = 70

HAR_train_2_5 = data.frame(pc_HAR_train$x[,1:k_5])

HAR_test_2_5 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_5 = as.data.frame(HAR_test_2_5[,1:k_5])

set.seed(120917)
#nn_model_1 = neuralnet(formula=theClass ~ ., data=data.frame(theClass, HAR_train_2_1), hidden=10, stepmax = 2e+05, threshold = 0.64, learningrate = 0.64, err.fct = 'sse', linear.output = FALSE)#

mynn_5 <- nnet(theClass ~ ., data = data.frame(theClass, HAR_train_2_5), size=10, decay=1.0e-2, maxit=2e+05)#, subset = sampidx
## evaluate the performance on the test data

#predict_class_1 = predict(nn_model_1,data.frame(c_3, HAR_test_2_1), rep = 1, all.units = T)
predict_class_5 = predict(mynn_5,data.frame(c_3, HAR_test_2_5), rep = 1, all.units = T)

#X=matrix(unlist(predict_class_1[3]), nrow = 6, byrow = F)
#(post_1=apply(X = X, MARGIN = 2, FUN = which.max))
X_5=matrix(unlist(predict_class_5), nrow = 2947, byrow = F)
(post_5=apply(X = X_5, MARGIN = 1, FUN = which.max))
# Split data
#train_idx <- sample(nrow(iris), 2/3 * nrow(iris))
#iris_train <- iris[train_idx, ]
## record the error on the test data: sum of the l1 norm of the error between the true class and the predicted class.
## we compute the sum of the errors for all the folds

accuracy_5=mean(post_5==c_3)*100
accuracy_5

Accuracy_2 = c(Accuracy_2, accuracy_5)

Confuse_5=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(post_5))$table)
Confuse_5

#################### k = 20 ####################

k_6 = 20

HAR_train_2_6 = data.frame(pc_HAR_train$x[,1:k_6])

HAR_test_2_6 = predict(pc_HAR_train, newdata = HAR_test.mat)

HAR_test_2_6 = as.data.frame(HAR_test_2_6[,1:k_6])

set.seed(120917)
#nn_model_1 = neuralnet(formula=theClass ~ ., data=data.frame(theClass, HAR_train_2_1), hidden=10, stepmax = 2e+05, threshold = 0.64, learningrate = 0.64, err.fct = 'sse', linear.output = FALSE)#

mynn_6 <- nnet(theClass ~ ., data = data.frame(theClass, HAR_train_2_6), size=10, decay=1.0e-2, maxit=2e+05)#, subset = sampidx
## evaluate the performance on the test data

#predict_class_1 = predict(nn_model_1,data.frame(c_3, HAR_test_2_1), rep = 1, all.units = T)
predict_class_6 = predict(mynn_6,data.frame(c_3, HAR_test_2_6), rep = 1, all.units = T)

#X=matrix(unlist(predict_class_1[3]), nrow = 6, byrow = F)
#(post_1=apply(X = X, MARGIN = 2, FUN = which.max))
X_6=matrix(unlist(predict_class_6), nrow = 2947, byrow = F)
(post_6=apply(X = X_6, MARGIN = 1, FUN = which.max))
# Split data
#train_idx <- sample(nrow(iris), 2/3 * nrow(iris))
#iris_train <- iris[train_idx, ]
## record the error on the test data: sum of the l1 norm of the error between the true class and the predicted class.
## we compute the sum of the errors for all the folds

accuracy_6=mean(post_6==c_3)*100
accuracy_6

Accuracy_2 = c(accuracy_6, Accuracy_2)

Confuse_6=kable(confusionMatrix(data = as.factor(c_3), reference = as.factor(post_6))$table)
Confuse_6

#################### Plot ######################

plot(c(20,30,40,50,60,70), Accuracy_2, xlab='Number of Principal Components', ylab='Accuracy', type = 'b', main="Neural Network")

#########################################################################################################

corrplot(Cor_Matrix_train, order = "hclust", method = 'circle')
corrplot(Cor_Matrix_train, order = "hclust", method = 'square')
corrplot(Cor_Matrix_train, order = "hclust", col=brewer.pal(n=8, name="RdYlBu"), method = 'circle')

rquery.cormat(Cor_Matrix)



a_t_stand=a_t[a_t$c_2==3, ]

a_t_sit=a_t[a_t$c_2==2, ]

a_t_lay=a_t[a_t$c_2==1, ]

a_t_walk=a_t[a_t$c_2==4, ]

a_t_walk_down=a_t[a_t$c_2==5, ]

a_t_walk_up=a_t[a_t$c_2==6, ]

hist(a_t_stand$HAR_train_1.tBodyAccmeanX,
     main="Stand X", 
     xlab="a_t_stand$HAR_train_1.tBodyAccmeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_stand$HAR_train_1.tBodyAccmeanY,
     main="Stand Y", 
     xlab="a_t_stand$HAR_train_1.tBodyAccmeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_stand$HAR_train_1.tBodyAccmeanZ,
     main="Stand Z", 
     xlab="a_t_stand$HAR_train_1.tBodyAccmeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(a_t_stand[1:3])

hist(a_t_sit$HAR_train_1.tBodyAccmeanX,
     main="Sit X", 
     xlab="a_t_sit$HAR_train_1.tBodyAccmeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_sit$HAR_train_1.tBodyAccmeanY,
     main="Sit Y", 
     xlab="a_t_sit$HAR_train_1.tBodyAccmeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_sit$HAR_train_1.tBodyAccmeanZ,
     main="Sit Z", 
     xlab="a_t_sit$HAR_train_1.tBodyAccmeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(a_t_sit[1:3])

hist(a_t_lay$HAR_train_1.tBodyAccmeanX,
     main="Lay X", 
     xlab="a_t_lay$HAR_train_1.tBodyAccmeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_lay$HAR_train_1.tBodyAccmeanY,
     main="Lay Y", 
     xlab="a_t_lay$HAR_train_1.tBodyAccmeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_lay$HAR_train_1.tBodyAccmeanZ,
     main="Lay Z", 
     xlab="a_t_lay$HAR_train_1.tBodyAccmeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(a_t_lay[1:3])

hist(a_t_walk$HAR_train_1.tBodyAccmeanX,
     main="Walk X", 
     xlab="a_t_walk$HAR_train_1.tBodyAccmeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_walk$HAR_train_1.tBodyAccmeanY,
     main="Walk Y", 
     xlab="a_t_walk$HAR_train_1.tBodyAccmeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_walk$HAR_train_1.tBodyAccmeanZ,
     main="Walk Z", 
     xlab="a_t_walk$HAR_train_1.tBodyAccmeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(a_t_walk[1:3])

hist(a_t_walk_down$HAR_train_1.tBodyAccmeanX,
     main="Walk Down X", 
     xlab="a_t_walk_down$HAR_train_1.tBodyAccmeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_walk_down$HAR_train_1.tBodyAccmeanY,
     main="Walk Down Y", 
     xlab="a_t_walk_down$HAR_train_1.tBodyAccmeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_walk_down$HAR_train_1.tBodyAccmeanZ,
     main="Walk Down Z", 
     xlab="a_t_walk_down$HAR_train_1.tBodyAccmeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(a_t_walk_down[1:3])

hist(a_t_walk_up$HAR_train_1.tBodyAccmeanX,
     main="Walk Up X", 
     xlab="a_t_walk_up$HAR_train_1.tBodyAccmeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_walk_up$HAR_train_1.tBodyAccmeanY,
     main="Walk Up Y", 
     xlab="a_t_walk_up$HAR_train_1.tBodyAccmeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(a_t_walk_up$HAR_train_1.tBodyAccmeanZ,
     main="Walk Up Z", 
     xlab="a_t_walk_up$HAR_train_1.tBodyAccmeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(a_t_walk_up[1:3])

g_t_sta=g_t[g_t$c_2<=3, ]

g_t_non_sta=g_t[g_t$c_2>3, ]

hist(g_t_sta$HAR_train_1.tBodyGyromeanX,
     main="Static X", 
     xlab="g_t_sta$HAR_train_1.tBodyGyromeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_sta$HAR_train_1.tBodyGyromeanY,
     main="Static Y", 
     xlab="g_t_sta$HAR_train_1.tBodyGyromeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_sta$HAR_train_1.tBodyGyromeanZ,
     main="Static Z", 
     xlab="g_t_sta$HAR_train_1.tBodyGyromeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(g_t_sta[1:3])

hist(g_t_non_sta$HAR_train_1.tBodyGyromeanX,
     main="Non Static X", 
     xlab="g_t_non_sta$HAR_train_1.tBodyGyromeanX", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_non_sta$HAR_train_1.tBodyGyromeanY,
     main="Non Static Y", 
     xlab="g_t_non_sta$HAR_train_1.tBodyGyromeanY", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

hist(g_t_non_sta$HAR_train_1.tBodyGyromeanZ,
     main="Non Static Z", 
     xlab="g_t_non_sta$HAR_train_1.tBodyGyromeanZ", 
     ylab="Density", 
     col='#99FFCC',
     las=1,
     breaks=15)

summary.all.variables(g_t_non_sta[1:3])

