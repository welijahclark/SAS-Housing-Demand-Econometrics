/*William-Elijah Clark wec19b STA 3064 Project A Code*/

/*I hereby certify that the following SAS code is my own original work*/

/** FOR CSV Files uploaded from Windows **/

FILENAME CSV "/home/u49665201/sasuser.v94/STA3064/Copy 2 of FY2021_50_County.csv" TERMSTR=CRLF;

/** Import the CSV file.  **/

PROC IMPORT DATAFILE=CSV
		    OUT=HUDdata
		    DBMS=CSV
		    REPLACE;
RUN;

/** Print the results. **/

PROC PRINT DATA=HUDdata; RUN;

/*****************************************/
/*Simple Linear Regression Model Attempts*/
/*****************************************/

proc reg data=HUDdata;
model rent50_0=pop2017;
run;

proc reg data=HUDdata;
model rent50_1=pop2017;
run;

proc reg data=HUDdata;
model rent50_2=pop2017;
run;

proc reg data=HUDdata;
model rent50_3=pop2017;
run;

proc reg data=HUDdata;
model rent50_4=pop2017;
run;

proc reg data=HUDdata;
model rent50_0=hu2017;
run;

proc reg data=HUDdata;
model rent50_1=hu2017;
run;

proc reg data=HUDdata;
model rent50_2=hu2017;
run;

proc reg data=HUDdata;
model rent50_3=hu2017;
run;

proc reg data=HUDdata;
model rent50_4=hu2017;
run;

/*Setting up more variables to try*/

data Housing;
 set HUDdata;
 PtoH = pop2017/hu2017;
 HtoP = hu2017/pop2017;
 transPop = pop2017**-1;
 transHu = hu2017**-1;
run;

/*Note: PtoH is a ratio of the population of an area to housing units in an area, while HtoP is number of housing units per person 
in an area. My hunch is that HtoP would be a better metric, but I don't actually know which will be better (or if it even makes a 
notable difference, for that matter). It doesn't fit the standard concept of price elasticity in economics, but it would make sense
regardless.*/

proc reg data=Housing;
model rent50_0=PtoH;
run;

proc reg data=Housing;
model rent50_1=PtoH;
run;

proc reg data=Housing;
model rent50_2=PtoH;
run;

proc reg data=Housing;
model rent50_3=PtoH;
run;

proc reg data=Housing;
model rent50_4=PtoH;
run;

proc reg data=Housing;
model rent50_0=HtoP;
run;

proc reg data=Housing;
model rent50_1=HtoP;
run;

proc reg data=Housing;
model rent50_2=HtoP;
run;

proc reg data=Housing;
model rent50_3=HtoP;
run;

proc reg data=Housing;
model rent50_4=HtoP;
run;

/*Models with Box-Cox transformations*/

proc transreg data=Housing;
model boxcox(rent50_2)=identity(HtoP);
run;

proc transreg data=Housing;
model boxcox(rent50_2)=identity(PtoH);
run;

proc transreg data=HUDdata;
model boxcox(rent50_2)=identity(pop2017);
run;

proc transreg data=HUDdata;
model boxcox(rent50_2)=identity(hu2017);
run;

/*Hmm. All of these suggest a transform of -0.75, so...let's go back up and add that into the data, I suppose.*/


proc reg data=Housing;
model rent50_0=transPop;
run;

proc reg data=Housing;
model rent50_1=transPop;
run;

proc reg data=Housing;
model rent50_2=transPop;
run;

proc reg data=Housing;
model rent50_3=transPop;
run;

proc reg data=Housing;
model rent50_4=transPop;
run;

proc reg data=Housing;
model rent50_0=transHu;
run;

proc reg data=Housing;
model rent50_1=transHu;
run;

proc reg data=Housing;
model rent50_2=transHu;
run;

proc reg data=Housing;
model rent50_3=transHu;
run;

proc reg data=Housing;
model rent50_4=transHu;
run;


/***************/
/*Scatter plots*/
/***************/

proc sgplot data=Housing;
	scatter X=rent50_2 Y=pop2017;
run;

proc sgplot data=Housing;
	scatter X=rent50_2 Y=hu2017;
run;

proc sgplot data=Housing;
	scatter X=rent50_2 Y=HtoP;
run;

proc sgplot data=Housing;
	scatter X=rent50_2 Y=PtoH;
run;

proc sgplot data=Housing;
	scatter X=rent50_2 Y=transHu;
run;

proc sgplot data=Housing;
	scatter X=rent50_2 Y=transPop;
run;

/**************/
/*LOESS Models*/
/**************/

proc loess data=Housing;
	model pop2017=rent50_2;
run;

proc loess data=Housing;
	model pop2017=rent50_2;
run;

proc loess data=Housing;
	model pop2017=HtoP;
run;

proc loess data=Housing;
	model pop2017=PtoH;
run;

proc loess data=Housing;
	model transPop=rent50_2;
run;

proc loess data=Housing;
	model transHu=rent50_2;
run;

/**************/
/*ANOVA Models*/
/**************/

proc ANOVA data=Housing;
	class hu2017;
	model rent50_2=hu2017;
run;

proc ANOVA data=Housing;
	class PtoH;
	model rent50_2=PtoH;
run;