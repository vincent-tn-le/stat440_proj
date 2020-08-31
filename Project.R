require(ggplot2)
source("gibbs-hbe.R")
data <- hbe.load()
N <- data$N
p <- data$p
K <- data$K
y <- data$y
V <- data$V
z <- data$z
# Run the sampler.
M <- 1000
out <- gibbs.fit(M, K, y, V, z_out = TRUE)
save(out, file = "out.RData")
# Evaluate sampler accuracy.
load(file = "out.RData")
# This (hardcoded) mapping changes based on the initialization!
mapping <- c("3", "2", "1p5", "2p5")
labels <- match(z, mapping)
sum(out$z[,1000] == labels) / N
# Plot accuracy over iterations.
outputs <- sapply(1:100, function(i) {
sum(out$z[,i*10] == labels) / N
})
df <- data.frame(x = 1:length(outputs), y = outputs)
ggplot(df, aes(x = 10*(1:100), y = outputs)) +
geom_point() +
geom_line(linetype = "dashed", color = "grey") +
theme_bw() +
labs(x = "M", y ="Accuracy")