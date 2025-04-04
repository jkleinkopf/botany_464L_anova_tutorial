# Botany 464L - ANOVA Tutorial in R
Follow along with the class slides [here](https://docs.google.com/presentation/d/1S4-4-KVPCI4bHiER66bpbaMPOLhRzXC2P3gtUWJYayM/edit?usp=sharing). 

## Part 1: Cleaning and loading data
### Step 1: Cleaning the data
Let's check to make sure our data looks good using Excel or Google Docs. We have four quantitative variables: `height_initial_cm`, `height_final_cm`, `biomass_final_g`, and a response variable of your choice (here I am calling it `response_3_cm`). These appear to all be numbers, so we're good there. If you have characters in any of those columns, make sure those are removed or converted to numbers. We also have a categorical variable, `treatment_group`, and these should be Control (plants 1-30), Treatment1 (plants 31-60), and Treatment2 (plants 61-90). 

Once our data looks good, let's create a new column to the right of `height_final_cm` called `growth_cm`. This will simply be `height_final_cm`-`height_initial_cm`. We can just type `=D2-C2` in the first empty cell to calculate the growth, and then we can fill down the column through plant 90.

![Apr-03-2025 20-50-10](https://github.com/user-attachments/assets/d9e878f3-fb37-439f-a279-8b00316aeb58)<br>

### Step 2: Setting up R Studio and loading the data
We're going to run our analyses in R. If you have the desktop version of R Studio, feel free to use that. However, we will use the [cloud version of R studio which you can access here](https://login.posit.cloud/login?redirect=%2F). After you make an account, click "new project" and select "New RStudio Project" from the dropdown menu. You can give your new project a name, if you wish.

<img width="963" alt="image" src="https://github.com/user-attachments/assets/79ca4d77-7630-47d4-9f83-5d600264db10" /><br>

Save the file [BotanyANOVA_2025_updated.R](BotanyANOVA_2025_updated.R) to your desktop, and then upload it and your data file (here I am calling it `data.csv` to your R studio project. To do so, you should click the small yellow circle with the white 'up' arrow in the panel in the bottom right. After you upload your files, they will appear in the list of files in the same panel. Click on the R script (BotanyANOVA_2025_updated.R), which will open it in the upper left panel.

<img width="940" alt="image" src="https://github.com/user-attachments/assets/5b71061b-d913-463d-9c09-f0c5f61cc6cf" /><br>

Go ahead and run lines 8-12 by clicking anywhere on the line and clicking "run" above, or command+enter (mac) or ctl+enter (PC), to install and load the packages we will use to analyze our data. This might take a minute or two. Then, let's load our data by running line 19. Make sure you change the filename from `data.csv` if yours has a different name. If it worked, you should see the data loaded in the upper right panel as `mydata`, and if you click on it, it will pop up in the upper left panel in a new tab.

```
mydata <- read.csv("data.csv")
```

![Apr-03-2025 21-16-17](https://github.com/user-attachments/assets/10134cb0-2a98-4257-9bf9-b45194e5967a)

## Part 2: Informal investigation of data
Before we analyze our data using statistical tests, let's build intuition about our data by plotting it. We will plot `treatment_group` on the x-axis, and we'll look at each response variable separately. We'll start by plotting `height_initial_cm` by treatment group. You can do this by running line 25 which should output a plot in the bottom right panel.

```
ggplot(mydata) + 
  aes(x = treatment_group, y = height_initial_cm) + 
  geom_jitter(aes(colour = treatment_group), width = 0.25, size = 4, alpha = 0.75) +
  theme(legend.position = "none")
```

<img width="1458" alt="image" src="https://github.com/user-attachments/assets/2c2df20e-e723-4301-8704-53bc5ce4ef2e" /><br>

We can see that the initial height of plants appears to be pretty similar across treatment groups, which is what we would expect (and want!), since we haven't yet applied any simulated herbivory treatments. There does appear to be an outlier in the Control group, but we'll see if we have to deal with that later.

### Part 3: Hypothesis testing

### The question and hypotheses
The question we are interested in for this project is _Does (simulated) herbivory affect plant growth and/or reproduction?_ We have two hypotheses:

1. **Null hypothesis**: Response means for each treatment group are not significantly different from each other.
2. **Alternative hypothesis**: The response mean for at least one treatment group is significantly different.

Since we're looking at how treatment group (a categorical variable) predicts quantitative response variables, we'll be using analysis of variance, or ANOVA, to see if plants treated with simulated herbivory (treatment 1 or 2) show a response that is significantly different from the control group, which received no herbivory treatment.

Let's go ahead and run the ANOVA on line  35. This will create a new object called `aov_mydata` in our environment.
```
aov_mydata <- aov(height_initial_cm ~ treatment_group, data = mydata)
``` 

### Assumptions of ANOVA
To use an ANOVA, we have to make sure that our data meet three assumptions: 

1. Independence of data
2. Normality of data (residuals are normally distributed)
3. Homogeneity of variances among treatment groups (the spread of data is similar among treatment groups).

### Making sure our data meet the assumptions of ANOVA
We know our data are independent, because we designed our experiment and collected our data with this in mind. However, we should use informal investigation and formal tests to determine if our data meet assumptions 2 and 3. Let's run lines 43-44 to visualize our data.

```
hist(aov_mydata$residuals)
qqPlot(aov_mydata$residuals, id = FALSE)
```

<img width="962" alt="image" src="https://github.com/user-attachments/assets/1b811b63-d00e-459b-b057-267dfd28ed82" /> <br>

Our data don't look perfectly normal, but not bad either. The qq-plot also suggests that most of our data looks to be pretty normal. However, in both cases we see an outlier that is much bigger than the rest of our data. Let's see what the Shapiro-Wilks test says by running line 45:

```
shapiro.test(aov_mydata$residuals)
```
<img width="427" alt="image" src="https://github.com/user-attachments/assets/b6b5b7c6-394d-4f19-948e-887f2671affb" /> <br>

A p-value of <0.05 tells us that our data (residuals) is not normally distributed. We'll have to deal with that in a second. Let's go ahead and see if variances are more or less equal among treatment groups. We can do this by looking at the plot we generated earlier in Part 2. To me, our data appear to have similar variances, but let's run line 48 to use Bartlett's Test to check:

```
bartlett.test(height_initial_cm ~ treatment_group, data = mydata)
```
<img width="573" alt="image" src="https://github.com/user-attachments/assets/abbc3be4-706f-4727-a04e-7e2fd0419b39" /> <br>
 
A p-value of >0.05 tells us that our data have equal variances, so we only have to worry about getting our data to be normal (this time!).

### How to deal with data that are not normally distributed or have unequal variances
To deal with data that are non-normal or have unequal variances, there are a couple things we can do: 
1. Identify and remove outliers
2. Transform the response variable

One easy way to identify outliers is to generate a simple boxplot for our variable of interest as a whole and for each treatment group. Let's try that now by running lines 54-55. 

```
boxplot(mydata$height_initial_cm)
boxplot(mydata$height_initial_cm ~ mydata$treatment_group)
```

<img width="834" alt="image" src="https://github.com/user-attachments/assets/4e8604a0-0013-4a68-827f-80d3fde182ef" /><br>

You might see figures that look something like this. I am noticing there is one large outlier in the control group that might be messing things up for us. Let's remove that point. To remove it, let's look at our data. Sort your data sheet by `height_initial_cm` and look for an exceptionally large outlier. It looks like plant number 20 is really big, so let's remove that one by putting `20` in the quotations in line 56:

```
mydata <- filter(mydata, plant_number != "20")
```
<img width="1162" alt="image" src="https://github.com/user-attachments/assets/ddbee24f-b2c9-424f-ac3f-5816877a6dae" /><br>

Go ahead and run line 56, and it should remove that data point from our dataset. If we re-run lines 35-48, we will find that our data are now normally distributed and variances are still equal:

<img width="930" alt="image" src="https://github.com/user-attachments/assets/223172a8-aa33-4a37-934a-e3f65b3d251e" /> <br>

If our variances were unequal according to Bartlett's Test, I would transform our data. 

