library("arules")
library("arulesViz")
library("datasets")


setwd("C:/Users/sstuff/Desktop")


gm_pos_v2 = read.csv("matrix+.csv", sep=",", row.names=1)
g_matrix_v2 <-as.matrix(gm_pos_v2)
g_matrix_v2

ncol(g_matrix_v2) #84 items (motifs)
nrow(g_matrix_v2)#139 transactions (genes)

geneTF.transactions_v2 <- as(g_matrix_v2, "transactions")
itemFrequencyPlot(geneTF.transactions_v2,topN=20,type="absolute")
nrow(geneTF.transactions_v2)
geneTF.transactions_v2
geneTF.rules_v2 <- apriori(geneTF.transactions_v2,
                        parameter = list(support=0.07, confidence=0.7))

inspect(geneTF.rules_v2)
summary(geneTF.rules_v2)
subrulesv2<-head(sort(geneTF.rules_v2, by="lift"), 10)
inspect(subrulesv2)
plot(subrulesv2, method="graph")
plot(subrulesv2, method="grouped")


