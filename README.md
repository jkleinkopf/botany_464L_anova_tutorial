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




## Part 2:

### Part 3:
