# Botany 464L ANOVA Analysis ----------------------------------------------
# Look at the slides for this lab for details of each step ----------------
# Have fun and ask questions :) -------------------------------------------


 
# Part 0: Set up the R environment ----------------------------------------
install.packages(c('ggplot2', 'dplyr', 'car', 'emmeans'))
library(ggplot2)
library(dplyr)
library(car)
library(emmeans) 


# Part 1: Import and visualize data ---------------------------------------
### Step 1: Clean your data/.csv file before beginning (use excel or similar)

### Step 2: Load in your data file as a .csv:
mydata <- read.csv("data.csv")



# Part 2: Informal investigation of our data ------------------------------
### Plot treatment groups against your variable of interest
ggplot(mydata) + 
  aes(x = treatment_group, y = height_initial_cm) + 
  geom_jitter(aes(colour = treatment_group), width = 0.25, size = 4, alpha = 0.75) +
  theme(legend.position = "none")



# Part 3A: Run hypothesis tests and check assumptions ---------------------

### Step 1: Run an ANOVA hypothesis test:
aov_mydata <- aov(height_initial_cm ~ treatment_group, data = mydata)

### Step 2: Check that assumptions of ANOVA are met:

##### Assumption 1: Independent data points
# We already know each data point collected is independent of the others!

##### Assumption 2: Normality of data
hist(aov_mydata$residuals)
qqPlot(aov_mydata$residuals, id = FALSE)
shapiro.test(aov_mydata$residuals)

##### Assumption 3: Homogeneity of variances
bartlett.test(height_initial_cm ~ treatment_group, data = mydata)



# Part 3B: IF normality or equal variances is NOT met ---------------------
### Step 1: Look for outliers, consider removing them, and redo tests above:
boxplot(mydata$height_initial_cm)
boxplot(mydata$height_initial_cm ~ mydata$treatment_group)
mydata <- filter(mydata, plant_number != "")

### Step 2: Try transforming (log(), sqrt(), etc.) your variable
### and rerun the ANOVA using the new variable.
hist(mydata$height_initial_cm)
mydata <- mydata %>% mutate(height_initial_cm_log = log(height_initial_cm))



# Part 4: Interpret results -----------------------------------------------
### If assumptions are met, view and save results of the ANOVA:
summary(aov_mydata)
capture.output(summary(aov_mydata), file = "height_initial_cm_anova.txt")

### If we cannot get our data to meet assumptions, we must use the
### Kruskal-Wallis test. This is a non-parametric version of ANOVA.
kruskal.test(height_initial_cm ~ treatment_group, data = mydata) 




# Part 5: Test differences among treatment groups -------------------------
### Tukey's Honest Significant Difference (HSD) tests pairs of treatment 
### groups to determine which one(s) differ from the control.
### SKIP if group means are equal (i.e., you must accept the null hypothesis)
tukey_mydata <- TukeyHSD(aov_mydata)
emm_cont <- emmeans(aov_mydata, specs = "treatment_group")
emm_cont %>% pairs(adjust = "tukey") %>% print()
plot(emm_cont,
     comparisons = TRUE,
     adjust = "tukey",
     horizontal = TRUE)

capture.output(emm_cont %>% pairs(adjust = "tukey") %>% print(), file = "height_initial_cm_anova.txt")

# Part 6: Graphing our results --------------------------------------------
### Build the base plot:
p <- ggplot(mydata, aes(x = treatment_group,
                        y = height_initial_cm, 
                        crop = FALSE, 
                        group = treatment_group, 
                        color = treatment_group))

### Plot a reference line for the global mean (all plants):
p <- p + geom_hline(yintercept = mean(mydata$height_initial_cm),
                    colour = "red", 
                    linetype = "dashed", 
                    linewidth = 0.3, 
                    alpha = 1)

### Plot a boxplot for each treatment group, size=.75 to stand out behind CI:
p <- p  + geom_boxplot(width = 0.25, alpha = 0.7)

### Plot data points for our observed data:
p <- p  + geom_point(position = position_jitter(w = 0.05, h = 0), alpha = .75)

### Let's plot a diamond at the mean for each group:
p <- p + stat_summary(fun = mean, geom = "point", shape = 23, size = 4.5  )

### Let's give our graph a descriptive title and accurate axis labels:
p <- p + ggtitle("Initial Height (cm) of Plants by Treatment Group") + 
         xlab("Treatment Group") + 
         ylab("Initial Height (cm)") + 
         theme(legend.position = "none")

### Change the colors of the groups, if you want, by uncommenting this:
#p <- p + scale_color_manual(values=c("darkcyan", "goldenrod","orangered4"))

### Let's take a look at our figure before we save it
p

### Let's save the figure:
ggsave("name_initial_height_cm.png", plot = p, dpi=600, width = 8, height = 6)

######### *** Don't forget to save the results of your *** #########
######### *** ANOVA and your figures to your desktop!! *** #########


