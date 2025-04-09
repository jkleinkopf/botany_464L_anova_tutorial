# Botany 464L: ANOVA Tutorial in R
Follow along with the class slides [here](https://docs.google.com/presentation/d/1S4-4-KVPCI4bHiER66bpbaMPOLhRzXC2P3gtUWJYayM/edit?usp=sharing). 

# Part 1: Cleaning and loading data
## Step 1: Cleaning the data
Let's check to make sure our data looks good using Excel or Google Docs. We have four quantitative variables: `height_initial_cm`, `height_final_cm`, `biomass_final_g`, and a response variable of your choice (here I am calling it `response_3_cm`). These appear to all be numbers, so we're good there. If you have characters in any of those columns, make sure those are removed or converted to numbers. We also have a categorical variable, `treatment_group`, and these should be Control (plants 1-30), Treatment1 (plants 31-60), and Treatment2 (plants 61-90). 

Once our data looks good, let's create a new column to the right of `height_final_cm` called `growth_cm`. This will simply be `height_final_cm`-`height_initial_cm`. We can just type `=D2-C2` in the first empty cell to calculate the growth, and then we can fill down the column through plant 90.

![Apr-03-2025 20-50-10](https://github.com/user-attachments/assets/d9e878f3-fb37-439f-a279-8b00316aeb58)<br>

## Step 2: Setting up R Studio and loading the data
We're going to run our analyses in R. If you have the desktop version of R Studio, feel free to use that. However, we will use the [cloud version of R studio which you can access here](https://login.posit.cloud/login?redirect=%2F). After you make an account, click "new project" and select "New RStudio Project" from the dropdown menu. You can give your new project a name, if you wish.

<img width="963" alt="image" src="https://github.com/user-attachments/assets/79ca4d77-7630-47d4-9f83-5d600264db10" /><br>

Save the file [BotanyANOVA_2025_updated.R](BotanyANOVA_2025_updated.R) to your desktop, and then upload it and your data file (here I am calling it [data.csv](data.csv)) to your R studio project. To do so, you should click the small yellow circle with the white 'up' arrow in the panel in the bottom right. After you upload your files, they will appear in the list of files in the same panel. Click on the R script (BotanyANOVA_2025_updated.R), which will open it in the upper left panel.

<img width="940" alt="image" src="https://github.com/user-attachments/assets/5b71061b-d913-463d-9c09-f0c5f61cc6cf" /><br>

Go ahead and run lines 8-12 by clicking anywhere on the line and clicking "run" above, or command+enter (mac) or ctl+enter (PC), to install and load the packages we will use to analyze our data. This might take a minute or two. Then, let's load our data by running line 19. Make sure you change the filename from [data.csv](data.csv) if yours has a different name. If it worked, you should see the data loaded in the upper right panel as `mydata`, and if you click on it, it will pop up in the upper left panel in a new tab.

```{r}
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
```

![Apr-03-2025 21-16-17](https://github.com/user-attachments/assets/10134cb0-2a98-4257-9bf9-b45194e5967a)

# Part 2: Informal investigation of data
Before we analyze our data using statistical tests, let's build intuition about our data by plotting it. We will plot `treatment_group` on the x-axis, and we'll look at each response variable separately. We'll start by plotting `height_initial_cm` by treatment group. You can do this by running lines 25-28 which should output a plot in the bottom right panel.

```
# Part 2: Informal investigation of our data ------------------------------
### Plot treatment groups against your variable of interest

ggplot(mydata) + 
  aes(x = treatment_group, y = height_initial_cm) + 
  geom_jitter(aes(colour = treatment_group), width = 0.25, size = 4, alpha = 0.75) +
  theme(legend.position = "none")
```

<img width="1458" alt="image" src="https://github.com/user-attachments/assets/2c2df20e-e723-4301-8704-53bc5ce4ef2e" /><br>

We can see that the initial height of plants appears to be pretty similar across treatment groups, which is what we would expect (and want!), since we haven't yet applied any simulated herbivory treatments. There does appear to be an outlier in the Control group, but we'll see if we have to deal with that later.

# Part 3: Hypothesis testing

## The question and hypotheses
The question we are interested in for this project is _Does (simulated) herbivory affect plant growth and/or reproduction?_ We have two hypotheses:

1. **Null hypothesis**: Response means for each treatment group are not significantly different from each other.
2. **Alternative hypothesis**: The response mean for at least one treatment group is significantly different.

Since we're looking at how treatment group (a categorical variable) predicts quantitative response variables, we'll be using analysis of variance, or ANOVA, to see if plants treated with simulated herbivory (treatment 1 or 2) show a response that is significantly different from the control group, which received no herbivory treatment.

Let's go ahead and run the ANOVA on line  35. This will create a new object called `aov_mydata` in our environment.
```
# Part 3A: Run hypothesis tests and check assumptions ---------------------
### Step 1: Run an ANOVA hypothesis test:
aov_mydata <- aov(height_initial_cm ~ treatment_group, data = mydata)
``` 

## Assumptions of ANOVA
To use an ANOVA, we have to make sure that our data meet three assumptions: 

1. Independence of data
2. Normality of data (residuals are normally distributed)
3. Homogeneity of variances among treatment groups (the spread of data is similar among treatment groups)

## Making sure our data meet the assumptions of ANOVA
We know our data are independent, because we designed our experiment and collected our data with this in mind. However, we should use informal investigation and formal tests to determine if our data meet assumptions 2 and 3. Let's run lines 43-46 to visualize and formally test our data to see if they meet our assumptions.

```
### Step 2: Check that assumptions of ANOVA are met:

##### Assumption 1: Independent data points
# We already know each data point collected is independent of the others!

##### Assumption 2: Normality of data
hist(aov_mydata$residuals)
qqPlot(aov_mydata$residuals, id = FALSE)
shapiro.test(aov_mydata$residuals)

##### Assumption 3: Homogeneity of variances
bartlett.test(height_initial_cm ~ treatment_group, data = mydata)
```

<img width="962" alt="image" src="https://github.com/user-attachments/assets/1b811b63-d00e-459b-b057-267dfd28ed82" /> <br>

Both the histogram and the qq-plot show that our data aren't perfectly normal, but not bad either. In both cases we see an outlier that is much bigger than the rest of our data. Let's see what the Shapiro-Wilks test said:

<img width="427" alt="image" src="https://github.com/user-attachments/assets/b6b5b7c6-394d-4f19-948e-887f2671affb" /> <br>

A p-value of <0.05 tells us that our data (residuals) are not normally distributed. We'll have to deal with that in a second. Let's go ahead and see if variances are more or less equal among treatment groups. We can do this by looking at the plot we generated earlier in Part 2. To me, our data appear to have similar variances, but let's see what Bartlett's Test said:

<img width="573" alt="image" src="https://github.com/user-attachments/assets/abbc3be4-706f-4727-a04e-7e2fd0419b39" /> <br>
 
A p-value of >0.05 tells us that our data have equal variances, so we only have to worry about getting our data to be normal (this time!).

## How to deal with data that are not normally distributed or have unequal variances
To deal with data that are non-normal or have unequal variances, there are a couple things we can do: 
1. Identify and remove outliers
2. Transform the response variable

One easy way to identify outliers is to generate a simple boxplot for our variable of interest as a whole and for each treatment group. Let's try that now by running lines 54-55. 

```
# Part 3B: IF normality or equal variances is NOT met ---------------------
### Step 1: Look for outliers, consider removing them, and redo tests above:

boxplot(mydata$height_initial_cm)
boxplot(mydata$height_initial_cm ~ mydata$treatment_group)
```

<img width="834" alt="image" src="https://github.com/user-attachments/assets/4e8604a0-0013-4a68-827f-80d3fde182ef" /><br>

You might see figures that look something like this. I am noticing there is one large outlier in the control group that might be messing things up for us. Let's remove that point. To remove it, let's look at our data. Sort your data sheet by `height_initial_cm` and look for an exceptionally large outlier. It looks like plant number 20 is really big, so let's remove that one by putting `20` in the quotations in line 56 and running it, which should remove that data point from our dataset.

```
mydata <- filter(mydata, plant_number != "20")
```
<img width="1162" alt="image" src="https://github.com/user-attachments/assets/ddbee24f-b2c9-424f-ac3f-5816877a6dae" /><br>

If we re-run lines 35-48, we will find that our data are now normally distributed and variances are still equal:

<img width="930" alt="image" src="https://github.com/user-attachments/assets/223172a8-aa33-4a37-934a-e3f65b3d251e" /> <br>

If our variances were unequal according to Bartlett's Test, I would consider transforming our variable of interest. Let's try making a histogram and seeing what our data look like by running line 60.

```
### Step 2: Try transforming (log(), sqrt(), etc.) your variable
### and rerun the ANOVA using the new variable.
hist(mydata$height_initial_cm)
```

<img width="844" alt="image" src="https://github.com/user-attachments/assets/ec625245-79af-4354-88bd-24ff5a74ea6c" /><br>

We know our variances are equal, and our data look pretty good (the histogram on the left), but if I saw something like the right-skewed histogram on the right, with a long tail, I would consider taking the log of the values for that variable (or you could square root the values) to see if that helps us meet our assumption of equal variances. You can run line 61 to do this, which will create a new variable called `height_initial_cm_log`, which is simply `height_initial_cm` but log-transformed. If you do this, you will have to replace every instance of `height_initial_cm` with `height_initial_cm_log` and re-run lines 35-48. 

**_You should keep track of the steps you take throughout hypothesis testing for each of your response variables. If your data are already normally distributed and have equal variances, then you should make a note of that. If your data are not normal or do not have equal variances, make a note of that. If you remove any outliers or transform your data, make a note of that too! These will be important things to include in the methods section of your paper._**

# Part 4: Interpreting our results
Once your data meet the three assumptions above, we can take a look at our ANOVA results. Let's run lines 67-68 to print and save the output of the ANOVA. 

```
# Part 4: Interpret results -----------------------------------------------
### If assumptions are met, view and save results of the ANOVA:
summary(aov_mydata)
capture.output(summary(aov_mydata), file = "height_initial_cm_anova.txt")
```
<img width="1465" alt="image" src="https://github.com/user-attachments/assets/9dc8cca9-e0f1-4faa-a999-f89600216b9a" /> <br>

We can see that the p-value (`Pr(>F)`) of 0.747 is greater than 0.05, which tells us that we **cannot reject the null hypothesis**, meaning that our group means are all statistically equal. For the variable we are looking at, `height_initial_cm`, this is what we want and would expect, since plants have not yet been treated for simulated herbivory. We can also see that our ANOVA output has been saved in the files panel as `height_initial_cm_anova.txt`. 

If for whatever reason you cannot get your data to be normally distributed and/or have equal variances, you can run a non-parametric version of ANOVA called the Kruskal-Wallis test. It will give you similar output that you can interpret just like the ANOVA.

# Part 5: Test differences among treatment groups
The Tukey Honestly Significant Differences (HSD) test compares pairs of treatment groups to see if they are significantly different. Typically, if your ANOVA p-value is >0.05, you will not need to run the Tukey HSD test, but we will just run them anyways and save the data, using lines 81-89:

```
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

capture.output(emm_cont %>% pairs(adjust = "tukey") %>% print(), file = "height_initial_cm_tukey.txt")
```

<img width="1459" alt="image" src="https://github.com/user-attachments/assets/2f313c4b-4470-427c-a2d9-fb3148734292" /><br>

We can see that the p-value for each pairwise comparison (for initial height) is >0.05, which tells us there are no differences between the means for each group. The figure on the right also shows us the same thing. The last line, `capture.output(emm_cont %>% pairs(adjust = "tukey") %>% print(), file = "height_initial_cm_tukey.txt")` will save the results of the Tukey HSD test to our files.

# Part 6: Graphing our results
The last step is to graph our results. We want to build a figure we can include in our greenhouse experiment final paper for each response variable of interest. We want to include all of our observations for the variable of interest (points), box-plots, a global mean (red dotted line), and treatment group means (diamonds). Then, we want to save our figure to our files. Let's do this by running lines 93-128.

```
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
```

<img width="1460" alt="image" src="https://github.com/user-attachments/assets/b1d42853-36bc-41b2-8b21-e3a9202cf9f6" /><br>

You should see a figure like this, and it will be saved in your files as `name_initial_height_cm.png`. You should modify line 123 so your name is in the filename. Congrats! You have used ANOVA to test for differences in means among treatment groups for our greenhouse experiment.

# Running ANOVA on the rest of the response variables:
This was a single example, using `height_initial_cm` as our variable of interest. **_We will not be including the ANOVA results, Tukey HSD results, or figure from this ANOVA analysis in our results._** However, you **will** have to run the above steps using your other response variables of interest: `growth_cm`, `biomass_final_g`, and your response variable of choice (`response_3_cm`). 

To do so, you should re-load your data (Part 1) and replace **all** instances of `height_initial_cm` with the other variables of interest, one at a time. One easy way you can do this is by simply using the keyboard shortcut command+f (mac) or ctl+f (pc) to find and replace all instances of `height_initial_cm` (for example, with `growth_cm`):

<img width="1454" alt="image" src="https://github.com/user-attachments/assets/1acfedaf-fdb4-4575-a2fe-3743e20d50da" /><br>

Then, do all of the parts and steps to analyze your data. At the end, you should have an ANOVA results file, Tukey HSD results file, and a figure for each response variable of interest. **Remember to change the filenames and figure titles/axis labels to reflect the response variable of interest!!!** Otherwise, you will have a hard time keeping track of which is which.

# Consolidating your data into tables
The results of your ANOVAs (e.g., `growth_cm_anova.txt`) and Tukey HSD (`growth_cm_tukey.txt`) from all of your variables will be incorporated into two tables. For the ANOVA table, you will include the Df, Sums of Squares, Mean Squares, F value, and p-value for each variable. For the Tukey HSD table, you will only include the p-values for the pairwise comparisons. Your tables will look like the examples below (but completed for all three of your variables).

<img width="1047" alt="image" src="https://github.com/user-attachments/assets/015b85ea-4dfd-4305-baf7-ea7d293cac3a" /> <br>

Make sure to save these tables and the figures to include them in your final paper. Feel free to email me with questions or concerns!

