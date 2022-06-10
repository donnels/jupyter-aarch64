#IP randon generator
set.seed(23)
ip_df <- data.frame(a = sample(c(1:254)),
                    b = sample(c(1:254)),
                    c = sample(c(1:254)),
                    d = sample(c(1:254)),
                    w = sample(c("zone 1", "zone 2"), 254, replace = TRUE))
head(ip_df)
