
LIBNAME TGIF 'C:\Users\DOMINIC\Documents\MKT6337\TGIF'; 
run;

data tgif_copy;
set tgif.tgif;
run;

proc sql;
create table tgif_clean
as
select points_ratio,email_send,email_open_rate,email_click_rate,email_forward_rate,email_send*email_open_rate as email_open, email_send*email_click_rate as email_click,email_send*email_forward_rate as email_forward,rest_loc_bar,rest_loc_Merch,rest_loc_Open,rest_loc_Patio,rest_loc_Rest,rest_loc_rm_serv,rest_loc_Take_out,rest_loc_cafe,rest_loc_unkn,time_breakfast,time_dinner,time_late_nite,time_lunch,time_unknown,disc_app,disc_beverage,disc_dessert,disc_employee,disc_food,disc_other,disc_ribs,disc_sandwich,disc_ticket,disc_type_bogo,disc_type_comp,disc_type_dolfood,disc_type_empl,disc_type_free,disc_type_other,disc_type_pctfood,disc_chan_advo,disc_chan_comp,disc_chan_demo,disc_chan_empl,disc_chan_entbk,disc_chan_gmms,disc_chan_gps,disc_chan_laten,disc_chan_local,disc_chan_other,disc_chan_part,disc_chan_smart,disc_chan_valc,disc_chan_value,disc_pct_tot,disc_pct_trans,items_tot_distinct,items_tot,net_amt_p_item,checks_tot,net_sales_p_chck,net_sales_tot,
fd_cat_alcoh*net_sales_tot as alcohol,fd_cat_app*net_sales_tot as appetizer,fd_cat_bev*net_sales_tot as beverage,fd_cat_brunc*net_sales_tot as brunch,fd_cat_buffe*net_sales_tot as buffet,fd_cat_burg*net_sales_tot as burger,fd_cat_combo*net_sales_tot as combo,fd_cat_dess*net_sales_tot as dessert,fd_cat_drink*net_sales_tot as drink,fd_cat_h_ent*net_sales_tot as h_entree,fd_cat_kids*net_sales_tot as kids,fd_cat_l_ent*net_sales_tot as l_entree,fd_cat_other*net_sales_tot as other,fd_cat_side*net_sales_tot as side,fd_cat_soupsal*net_sales_tot as soup_sal,fd_cat_steak*net_sales_tot as steak,
fd_cat_alcoh,fd_cat_app,fd_cat_bev,fd_cat_brunc,fd_cat_buffe,fd_cat_burg,fd_cat_combo,fd_cat_dess,fd_cat_drink,fd_cat_h_ent,fd_cat_kids,fd_cat_l_ent,fd_cat_other,fd_cat_side,fd_cat_soupsal,fd_cat_steak,
days_between_trans,tenure_day,age,guests_last_12mo,customer_number
from tgif_copy
where disc_pct_tot<= 1
and net_sales_tot >= net_amt_p_item;

proc means data = tgif.tgif_clean;
var age;
where age > 4;
run;

data tgif_impute;
set tgif_clean;
if age <= 4 then age = 47;
run;


PROC SORT DATA = tgif_impute;  BY customer_number; RUN;


PROC STANDARD DATA= tgif_impute MEAN=0 STD=1 OUT= standard;

var email_send	disc_pct_tot  days_between_trans	tenure_day	age;

RUN;

proc sql ;
create table standard_filtered
as
select * from standard
where net_amt_p_item <= 8;
run;



/*
proc fastclus data= standard_filtered maxc= 5 out= clus_final (keep = customer_number cluster);
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;
*/
proc fastclus data= standard maxc= 5 out= clus_final (keep = customer_number cluster);
/*var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;
*/
var email_send 
/*
rest_loc_bar rest_loc_Merch rest_loc_Open rest_loc_Patio rest_loc_Rest rest_loc_rm_serv rest_loc_Take_out rest_loc_cafe rest_loc_unkn 
*/
/*
time_breakfast time_late_nite time_dinner 
*/
/*
disc_app disc_beverage disc_dessert disc_food disc_other disc_ribs disc_sandwich disc_ticket disc_type_bogo disc_type_comp disc_type_dolfood disc_type_free disc_type_other disc_type_pctfood disc_chan_advo disc_chan_demo disc_chan_empl disc_chan_gmms disc_chan_gps disc_chan_local disc_chan_other disc_chan_value
*/
disc_pct_tot  
days_between_trans tenure_day age;
run;


proc corr data = standard;
var email_send 
/*
rest_loc_bar rest_loc_Merch rest_loc_Open rest_loc_Patio rest_loc_Rest rest_loc_rm_serv rest_loc_Take_out rest_loc_cafe rest_loc_unkn 
*/
/*
time_breakfast time_late_nite time_dinner 
*/
/*
disc_app disc_beverage disc_dessert disc_food disc_other disc_ribs disc_sandwich disc_ticket disc_type_bogo disc_type_comp disc_type_dolfood disc_type_free disc_type_other disc_type_pctfood disc_chan_advo disc_chan_demo disc_chan_empl disc_chan_gmms disc_chan_gps disc_chan_local disc_chan_other disc_chan_value
*/
disc_pct_tot 
net_amt_p_item net_sales_p_chck  
alcohol brunch buffet burger combo dessert drink h_entree kids l_entree soup_sal steak 
days_between_trans tenure_day age customer_number;
run;

/* without net_sales_tot */

proc corr data = standard;
var email_send 
/*
rest_loc_bar rest_loc_Merch rest_loc_Open rest_loc_Patio rest_loc_Rest rest_loc_rm_serv rest_loc_Take_out rest_loc_cafe rest_loc_unkn 
*/
/*
time_breakfast time_late_nite time_dinner 
*/
/*
disc_app disc_beverage disc_dessert disc_food disc_other disc_ribs disc_sandwich disc_ticket disc_type_bogo disc_type_comp disc_type_dolfood disc_type_free disc_type_other disc_type_pctfood disc_chan_advo disc_chan_demo disc_chan_empl disc_chan_gmms disc_chan_gps disc_chan_local disc_chan_other disc_chan_value
*/
disc_pct_tot  
brunch buffet kids  
days_between_trans tenure_day age;
run;









/* without net_sales_tot refined */

proc corr data = standard;
var brunch buffet drink kids ;
run;

/*

points_ratio,email_send,email_open_rate,email_click_rate,email_forward_rate,email_open,email_click,email_forward,
rest_loc_bar,rest_loc_Merch,rest_loc_Open,rest_loc_Patio,rest_loc_Rest,rest_loc_rm_serv,rest_loc_Take_out,rest_loc_cafe,rest_loc_unkn,
time_breakfast,time_dinner,time_late_nite,time_lunch,time_unknown,
disc_app,disc_beverage,disc_dessert,disc_employee,disc_food,disc_other,disc_ribs,disc_sandwich,disc_ticket,disc_type_bogo,disc_type_comp,disc_type_dolfood,disc_type_empl,disc_type_free,disc_type_other,disc_type_pctfood,disc_chan_advo,disc_chan_comp,disc_chan_demo,disc_chan_empl,disc_chan_entbk,disc_chan_gmms,disc_chan_gps,disc_chan_laten,disc_chan_local,disc_chan_other,disc_chan_part,disc_chan_smart,disc_chan_valc,disc_chan_value,disc_pct_tot,disc_pct_trans,
items_tot_distinct,items_tot,net_amt_p_item,checks_tot,net_sales_p_chck,net_sales_tot,
alcohol,appetizer,beverage,brunch,buffet,burger,combo,dessert,drink,h_entree,kids,l_entree,other,side,soup_sal,steak,
days_between_trans,tenure_day,age,guests_last_12mo,customer_number
*/

/* Good enough;

proc fastclus data= standard_filtered maxc= 5 out= clus_final (keep = customer_number cluster);
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

*/



/*---*/

proc sort data = clus_final; by customer_number; run;

proc sort data = tgif_impute; by customer_number; run;


data tgif.final_clusters;
merge tgif_impute clus_final; by customer_number ; run;


proc sort data = tgif.final_clusters; by cluster; run;


proc means data = tgif.final_clusters;
/*
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
*/
run;


data cluster_1;
set tgif.final_clusters;
if cluster = 1;

data cluster_2;
set tgif.final_clusters;
if cluster = 2;

data cluster_3;
set tgif.final_clusters;
if cluster = 3;

data cluster_4;
set tgif.final_clusters;
if cluster = 4;

data cluster_5;
set tgif.final_clusters;
if cluster = 5;


/*
data mba_cl_temp;
set tgif.final_clusters;
if cluster = 1;
run;
*/


data mba_cl_1;
set tgif.final_clusters;
if cluster = 1;
logit_alcoh = 0;  logit_app  = 0 ; logit_bev  = 0 ; 
logit_brunc  = 0 ; logit_buffe  = 0 ; logit_burg  = 0 ; 
logit_combo  = 0 ; logit_dress  = 0 ; logit_drink  = 0 ; 
logit_h_ent  = 0 ; logit_kids  = 0 ; logit_l_ent  = 0 ; 
logit_other  = 0 ; logit_side  = 0 ; logit_soupsal  = 0 ; logit_steak = 0;

if fd_cat_alcoh	> 0 then logit_alcoh = 1; 
if fd_cat_app	> 0 then logit_app  = 1 ; 
if fd_cat_bev	> 0 then logit_bev  = 1 ; 
if fd_cat_brunc	> 0 then logit_brunc  = 1 ; 
if fd_cat_buffe	> 0 then logit_buffe  = 1 ; 
if fd_cat_burg	> 0 then logit_burg  = 1 ; 
if fd_cat_combo	> 0 then logit_combo  = 1 ; 
if fd_cat_dess	> 0 then logit_dress  = 1 ; 
if fd_cat_drink	> 0 then logit_drink  = 1 ; 
if fd_cat_h_ent	> 0 then logit_h_ent  = 1 ; 
if fd_cat_kids	> 0 then logit_kids  = 1 ; 
if fd_cat_l_ent	> 0 then logit_l_ent  = 1 ; 
if fd_cat_other	> 0 then logit_other  = 1 ; 
if fd_cat_side	> 0 then logit_side  = 1 ; 
if fd_cat_soupsal > 0 then logit_soupsal  = 1 ; 
if fd_cat_steak > 0 then logit_steak = 1;
run;


data mba_cl_2;
set tgif.final_clusters;
if cluster = 2;
logit_alcoh = 0;  logit_app  = 0 ; logit_bev  = 0 ; 
logit_brunc  = 0 ; logit_buffe  = 0 ; logit_burg  = 0 ; 
logit_combo  = 0 ; logit_dress  = 0 ; logit_drink  = 0 ; 
logit_h_ent  = 0 ; logit_kids  = 0 ; logit_l_ent  = 0 ; 
logit_other  = 0 ; logit_side  = 0 ; logit_soupsal  = 0 ; logit_steak = 0;

if fd_cat_alcoh	> 0 then logit_alcoh = 1; 
if fd_cat_app	> 0 then logit_app  = 1 ; 
if fd_cat_bev	> 0 then logit_bev  = 1 ; 
if fd_cat_brunc	> 0 then logit_brunc  = 1 ; 
if fd_cat_buffe	> 0 then logit_buffe  = 1 ; 
if fd_cat_burg	> 0 then logit_burg  = 1 ; 
if fd_cat_combo	> 0 then logit_combo  = 1 ; 
if fd_cat_dess	> 0 then logit_dress  = 1 ; 
if fd_cat_drink	> 0 then logit_drink  = 1 ; 
if fd_cat_h_ent	> 0 then logit_h_ent  = 1 ; 
if fd_cat_kids	> 0 then logit_kids  = 1 ; 
if fd_cat_l_ent	> 0 then logit_l_ent  = 1 ; 
if fd_cat_other	> 0 then logit_other  = 1 ; 
if fd_cat_side	> 0 then logit_side  = 1 ; 
if fd_cat_soupsal > 0 then logit_soupsal  = 1 ; 
if fd_cat_steak > 0 then logit_steak = 1;
run;


data mba_cl_3;
set tgif.final_clusters;
if cluster = 3;
logit_alcoh = 0;  logit_app  = 0 ; logit_bev  = 0 ; 
logit_brunc  = 0 ; logit_buffe  = 0 ; logit_burg  = 0 ; 
logit_combo  = 0 ; logit_dress  = 0 ; logit_drink  = 0 ; 
logit_h_ent  = 0 ; logit_kids  = 0 ; logit_l_ent  = 0 ; 
logit_other  = 0 ; logit_side  = 0 ; logit_soupsal  = 0 ; logit_steak = 0;

if fd_cat_alcoh	> 0 then logit_alcoh = 1; 
if fd_cat_app	> 0 then logit_app  = 1 ; 
if fd_cat_bev	> 0 then logit_bev  = 1 ; 
if fd_cat_brunc	> 0 then logit_brunc  = 1 ; 
if fd_cat_buffe	> 0 then logit_buffe  = 1 ; 
if fd_cat_burg	> 0 then logit_burg  = 1 ; 
if fd_cat_combo	> 0 then logit_combo  = 1 ; 
if fd_cat_dess	> 0 then logit_dress  = 1 ; 
if fd_cat_drink	> 0 then logit_drink  = 1 ; 
if fd_cat_h_ent	> 0 then logit_h_ent  = 1 ; 
if fd_cat_kids	> 0 then logit_kids  = 1 ; 
if fd_cat_l_ent	> 0 then logit_l_ent  = 1 ; 
if fd_cat_other	> 0 then logit_other  = 1 ; 
if fd_cat_side	> 0 then logit_side  = 1 ; 
if fd_cat_soupsal > 0 then logit_soupsal  = 1 ; 
if fd_cat_steak > 0 then logit_steak = 1;
run;



data mba_cl_4;
set tgif.final_clusters;
if cluster = 4;
logit_alcoh = 0;  logit_app  = 0 ; logit_bev  = 0 ; 
logit_brunc  = 0 ; logit_buffe  = 0 ; logit_burg  = 0 ; 
logit_combo  = 0 ; logit_dress  = 0 ; logit_drink  = 0 ; 
logit_h_ent  = 0 ; logit_kids  = 0 ; logit_l_ent  = 0 ; 
logit_other  = 0 ; logit_side  = 0 ; logit_soupsal  = 0 ; logit_steak = 0;

if fd_cat_alcoh	> 0 then logit_alcoh = 1; 
if fd_cat_app	> 0 then logit_app  = 1 ; 
if fd_cat_bev	> 0 then logit_bev  = 1 ; 
if fd_cat_brunc	> 0 then logit_brunc  = 1 ; 
if fd_cat_buffe	> 0 then logit_buffe  = 1 ; 
if fd_cat_burg	> 0 then logit_burg  = 1 ; 
if fd_cat_combo	> 0 then logit_combo  = 1 ; 
if fd_cat_dess	> 0 then logit_dress  = 1 ; 
if fd_cat_drink	> 0 then logit_drink  = 1 ; 
if fd_cat_h_ent	> 0 then logit_h_ent  = 1 ; 
if fd_cat_kids	> 0 then logit_kids  = 1 ; 
if fd_cat_l_ent	> 0 then logit_l_ent  = 1 ; 
if fd_cat_other	> 0 then logit_other  = 1 ; 
if fd_cat_side	> 0 then logit_side  = 1 ; 
if fd_cat_soupsal > 0 then logit_soupsal  = 1 ; 
if fd_cat_steak > 0 then logit_steak = 1;
run;



data mba_cl_5;
set tgif.final_clusters;
if cluster = 5;
logit_alcoh = 0;  logit_app  = 0 ; logit_bev  = 0 ; 
logit_brunc  = 0 ; logit_buffe  = 0 ; logit_burg  = 0 ; 
logit_combo  = 0 ; logit_dress  = 0 ; logit_drink  = 0 ; 
logit_h_ent  = 0 ; logit_kids  = 0 ; logit_l_ent  = 0 ; 
logit_other  = 0 ; logit_side  = 0 ; logit_soupsal  = 0 ; logit_steak = 0;

if fd_cat_alcoh	> 0 then logit_alcoh = 1; 
if fd_cat_app	> 0 then logit_app  = 1 ; 
if fd_cat_bev	> 0 then logit_bev  = 1 ; 
if fd_cat_brunc	> 0 then logit_brunc  = 1 ; 
if fd_cat_buffe	> 0 then logit_buffe  = 1 ; 
if fd_cat_burg	> 0 then logit_burg  = 1 ; 
if fd_cat_combo	> 0 then logit_combo  = 1 ; 
if fd_cat_dess	> 0 then logit_dress  = 1 ; 
if fd_cat_drink	> 0 then logit_drink  = 1 ; 
if fd_cat_h_ent	> 0 then logit_h_ent  = 1 ; 
if fd_cat_kids	> 0 then logit_kids  = 1 ; 
if fd_cat_l_ent	> 0 then logit_l_ent  = 1 ; 
if fd_cat_other	> 0 then logit_other  = 1 ; 
if fd_cat_side	> 0 then logit_side  = 1 ; 
if fd_cat_soupsal > 0 then logit_soupsal  = 1 ; 
if fd_cat_steak > 0 then logit_steak = 1;
run;


proc means data = cluster_1;
var alcohol appetizer beverage brunch buffet burger combo dessert drink h_entree kids l_entree other side soup_sal steak;
run;

/*Alcohol h_entree  appetizer*/

proc logistic descending data = mba_cl_1;
model 
logit_alcoh = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_h_ent   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc logistic descending data = mba_cl_1;
model 
logit_h_ent = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_alcoh   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc means data = cluster_2;
var alcohol appetizer beverage brunch buffet burger combo dessert drink h_entree kids l_entree other side soup_sal steak;
run;

/* h_entree alcohol   appetizer*/

proc logistic descending data = mba_cl_2;
model 
logit_alcoh = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_h_ent   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc logistic descending data = mba_cl_2;
model 
logit_h_ent = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_alcoh   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc means data = cluster_3;
var alcohol appetizer beverage brunch buffet burger combo dessert drink h_entree kids l_entree other side soup_sal steak;
run;

/* h_entree appetizer   alcohol*/

proc logistic descending data = mba_cl_3;
model 
logit_alcoh = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_h_ent   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc logistic descending data = mba_cl_3;
model 
logit_h_ent = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_alcoh   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;


proc means data = cluster_4;
var alcohol appetizer beverage brunch buffet burger combo dessert drink h_entree kids l_entree other side soup_sal steak;
run;

/* h_entree alcohol   appetizer*/

proc logistic descending data = mba_cl_4;
model 
logit_alcoh = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_h_ent   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc logistic descending data = mba_cl_4;
model 
logit_h_ent = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_alcoh   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc means data = cluster_5;
var alcohol appetizer beverage brunch buffet burger combo dessert drink h_entree kids l_entree other side soup_sal steak;
run;

/*Alcohol*/

proc logistic descending data = mba_cl_5;
model 
logit_alcoh = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_h_ent   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc logistic descending data = mba_cl_5;
model 
logit_h_ent = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_alcoh   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

/*
proc means data = products;
var logit_a logit_b logit_c logit_d logit_e;
run;


proc logistic descending data = products;
model logit_c = logit_a logit_b logit_d logit_e; run;
*/



proc means data = cluster_1; 
var net_amt_p_item items_tot; 
run;

proc reg data = cluster_1; 
model items_tot = email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age /VIF COLLIN; 
run;

proc means data = cluster_2; 
var net_amt_p_item items_tot; 
run;

proc reg data = cluster_2; 
model items_tot = email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age /VIF COLLIN; 
run;

proc means data = cluster_3; 
var net_amt_p_item items_tot; 
run;

proc reg data = cluster_3; 
model items_tot = email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age /VIF COLLIN; 
run;

proc means data = cluster_4; 
var net_amt_p_item items_tot; 
run;

proc reg data = cluster_4; 
model items_tot = email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age /VIF COLLIN; 
run;

proc means data = cluster_5; 
var net_amt_p_item items_tot; 
run;

proc reg data = cluster_5; 
model items_tot = email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age /VIF COLLIN; 
run;


























/*DRAFT - FINAL*/



LIBNAME TGIF 'C:\Users\DOMINIC\Documents\MKT6337\TGIF'; 
run;

data tgif_copy;
set tgif.tgif;
run;

proc sql;
create table tgif_clean
as
select points_ratio,email_send,email_open_rate,email_click_rate,email_forward_rate,email_send*email_open_rate as email_open, email_send*email_click_rate as email_click,email_send*email_forward_rate as email_forward,rest_loc_bar,rest_loc_Merch,rest_loc_Open,rest_loc_Patio,rest_loc_Rest,rest_loc_rm_serv,rest_loc_Take_out,rest_loc_cafe,rest_loc_unkn,time_breakfast,time_dinner,time_late_nite,time_lunch,time_unknown,disc_app,disc_beverage,disc_dessert,disc_employee,disc_food,disc_other,disc_ribs,disc_sandwich,disc_ticket,disc_type_bogo,disc_type_comp,disc_type_dolfood,disc_type_empl,disc_type_free,disc_type_other,disc_type_pctfood,disc_chan_advo,disc_chan_comp,disc_chan_demo,disc_chan_empl,disc_chan_entbk,disc_chan_gmms,disc_chan_gps,disc_chan_laten,disc_chan_local,disc_chan_other,disc_chan_part,disc_chan_smart,disc_chan_valc,disc_chan_value,disc_pct_tot,disc_pct_trans,items_tot_distinct,items_tot,net_amt_p_item,checks_tot,net_sales_p_chck,net_sales_tot,
fd_cat_alcoh*net_sales_tot as alcohol,fd_cat_app*net_sales_tot as appetizer,fd_cat_bev*net_sales_tot as beverage,fd_cat_brunc*net_sales_tot as brunch,fd_cat_buffe*net_sales_tot as buffet,fd_cat_burg*net_sales_tot as burger,fd_cat_combo*net_sales_tot as combo,fd_cat_dess*net_sales_tot as dessert,fd_cat_drink*net_sales_tot as drink,fd_cat_h_ent*net_sales_tot as h_entree,fd_cat_kids*net_sales_tot as kids,fd_cat_l_ent*net_sales_tot as l_entree,fd_cat_other*net_sales_tot as other,fd_cat_side*net_sales_tot as side,fd_cat_soupsal*net_sales_tot as soup_sal,fd_cat_steak*net_sales_tot as steak,
fd_cat_alcoh,fd_cat_app,fd_cat_bev,fd_cat_brunc,fd_cat_buffe,fd_cat_burg,fd_cat_combo,fd_cat_dess,fd_cat_drink,fd_cat_h_ent,fd_cat_kids,fd_cat_l_ent,fd_cat_other,fd_cat_side,fd_cat_soupsal,fd_cat_steak,
days_between_trans,tenure_day,age,guests_last_12mo,customer_number
from tgif_copy
where disc_pct_tot<= 1
and net_sales_tot >= net_amt_p_item;

proc means data = tgif.tgif_clean;
var age;
where age > 4;
run;

data tgif_impute;
set tgif_clean;
if age <= 4 then age = 47;
run;


PROC SORT DATA = tgif_impute;  BY customer_number; RUN;


PROC STANDARD DATA= tgif_impute MEAN=0 STD=1 OUT= standard;

var email_send	disc_pct_tot  days_between_trans	tenure_day	age;

RUN;

proc sql ;
create table standard_filtered
as
select * from standard
where net_amt_p_item <= 8;
run;



/*
proc fastclus data= standard_filtered maxc= 5 out= clus_final (keep = customer_number cluster);
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;
*/
proc fastclus data= standard maxc= 5 out= clus_final (keep = customer_number cluster);
/*var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;
*/
var email_send 
/*
rest_loc_bar rest_loc_Merch rest_loc_Open rest_loc_Patio rest_loc_Rest rest_loc_rm_serv rest_loc_Take_out rest_loc_cafe rest_loc_unkn 
*/
/*
time_breakfast time_late_nite time_dinner 
*/
/*
disc_app disc_beverage disc_dessert disc_food disc_other disc_ribs disc_sandwich disc_ticket disc_type_bogo disc_type_comp disc_type_dolfood disc_type_free disc_type_other disc_type_pctfood disc_chan_advo disc_chan_demo disc_chan_empl disc_chan_gmms disc_chan_gps disc_chan_local disc_chan_other disc_chan_value
*/
disc_pct_tot  
days_between_trans tenure_day age;
run;


proc fastclus data= standard_filtered maxc= 5 out= clus_temp (keep = customer_number cluster);
/*var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;
*/
var email_send 
/*
rest_loc_bar rest_loc_Merch rest_loc_Open rest_loc_Patio rest_loc_Rest rest_loc_rm_serv rest_loc_Take_out rest_loc_cafe rest_loc_unkn 
*/
/*
time_breakfast time_late_nite time_dinner 
*/
/*
disc_app disc_beverage disc_dessert disc_food disc_other disc_ribs disc_sandwich disc_ticket disc_type_bogo disc_type_comp disc_type_dolfood disc_type_free disc_type_other disc_type_pctfood disc_chan_advo disc_chan_demo disc_chan_empl disc_chan_gmms disc_chan_gps disc_chan_local disc_chan_other disc_chan_value
*/
disc_pct_tot  
fd_cat_brunc fd_cat_buffe  
days_between_trans tenure_day age;
run;


proc corr data = standard;
var email_send 
/*
rest_loc_bar rest_loc_Merch rest_loc_Open rest_loc_Patio rest_loc_Rest rest_loc_rm_serv rest_loc_Take_out rest_loc_cafe rest_loc_unkn 
*/
/*
time_breakfast time_late_nite time_dinner 
*/
/*
disc_app disc_beverage disc_dessert disc_food disc_other disc_ribs disc_sandwich disc_ticket disc_type_bogo disc_type_comp disc_type_dolfood disc_type_free disc_type_other disc_type_pctfood disc_chan_advo disc_chan_demo disc_chan_empl disc_chan_gmms disc_chan_gps disc_chan_local disc_chan_other disc_chan_value
*/
disc_pct_tot 
net_amt_p_item net_sales_p_chck  
alcohol brunch buffet burger combo dessert drink h_entree kids l_entree soup_sal steak 
days_between_trans tenure_day age customer_number;
run;

/* without net_sales_tot */

proc corr data = standard;
var email_send 
/*
rest_loc_bar rest_loc_Merch rest_loc_Open rest_loc_Patio rest_loc_Rest rest_loc_rm_serv rest_loc_Take_out rest_loc_cafe rest_loc_unkn 
*/
/*
time_breakfast time_late_nite time_dinner 
*/
/*
disc_app disc_beverage disc_dessert disc_food disc_other disc_ribs disc_sandwich disc_ticket disc_type_bogo disc_type_comp disc_type_dolfood disc_type_free disc_type_other disc_type_pctfood disc_chan_advo disc_chan_demo disc_chan_empl disc_chan_gmms disc_chan_gps disc_chan_local disc_chan_other disc_chan_value
*/
disc_pct_tot  
brunch buffet kids  
days_between_trans tenure_day age;
run;









/* without net_sales_tot refined */

proc corr data = standard;
var brunch buffet drink kids ;
run;

/*

points_ratio,email_send,email_open_rate,email_click_rate,email_forward_rate,email_open,email_click,email_forward,
rest_loc_bar,rest_loc_Merch,rest_loc_Open,rest_loc_Patio,rest_loc_Rest,rest_loc_rm_serv,rest_loc_Take_out,rest_loc_cafe,rest_loc_unkn,
time_breakfast,time_dinner,time_late_nite,time_lunch,time_unknown,
disc_app,disc_beverage,disc_dessert,disc_employee,disc_food,disc_other,disc_ribs,disc_sandwich,disc_ticket,disc_type_bogo,disc_type_comp,disc_type_dolfood,disc_type_empl,disc_type_free,disc_type_other,disc_type_pctfood,disc_chan_advo,disc_chan_comp,disc_chan_demo,disc_chan_empl,disc_chan_entbk,disc_chan_gmms,disc_chan_gps,disc_chan_laten,disc_chan_local,disc_chan_other,disc_chan_part,disc_chan_smart,disc_chan_valc,disc_chan_value,disc_pct_tot,disc_pct_trans,
items_tot_distinct,items_tot,net_amt_p_item,checks_tot,net_sales_p_chck,net_sales_tot,
alcohol,appetizer,beverage,brunch,buffet,burger,combo,dessert,drink,h_entree,kids,l_entree,other,side,soup_sal,steak,
days_between_trans,tenure_day,age,guests_last_12mo,customer_number
*/

/* Good enough;

proc fastclus data= standard_filtered maxc= 5 out= clus_final (keep = customer_number cluster);
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

*/



/*---*/

proc sort data = clus_final; by customer_number; run;

proc sort data = tgif_impute; by customer_number; run;


data tgif.final_clusters;
merge tgif_impute clus_final; by customer_number ; run;


proc sort data = tgif.final_clusters; by cluster; run;


proc means data = tgif.final_clusters;
/*
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
*/
run;


data cluster_1;
set tgif.final_clusters;
if cluster = 1;

data cluster_2;
set tgif.final_clusters;
if cluster = 2;

data cluster_3;
set tgif.final_clusters;
if cluster = 3;

data cluster_4;
set tgif.final_clusters;
if cluster = 4;

data cluster_5;
set tgif.final_clusters;
if cluster = 5;


/*
data mba_cl_temp;
set tgif.final_clusters;
if cluster = 1;
run;
*/


data mba_cl_1;
set tgif.final_clusters;
if cluster = 1;
logit_alcoh = 0;  logit_app  = 0 ; logit_bev  = 0 ; 
logit_brunc  = 0 ; logit_buffe  = 0 ; logit_burg  = 0 ; 
logit_combo  = 0 ; logit_dress  = 0 ; logit_drink  = 0 ; 
logit_h_ent  = 0 ; logit_kids  = 0 ; logit_l_ent  = 0 ; 
logit_other  = 0 ; logit_side  = 0 ; logit_soupsal  = 0 ; logit_steak = 0;

if fd_cat_alcoh	> 0 then logit_alcoh = 1; 
if fd_cat_app	> 0 then logit_app  = 1 ; 
if fd_cat_bev	> 0 then logit_bev  = 1 ; 
if fd_cat_brunc	> 0 then logit_brunc  = 1 ; 
if fd_cat_buffe	> 0 then logit_buffe  = 1 ; 
if fd_cat_burg	> 0 then logit_burg  = 1 ; 
if fd_cat_combo	> 0 then logit_combo  = 1 ; 
if fd_cat_dess	> 0 then logit_dress  = 1 ; 
if fd_cat_drink	> 0 then logit_drink  = 1 ; 
if fd_cat_h_ent	> 0 then logit_h_ent  = 1 ; 
if fd_cat_kids	> 0 then logit_kids  = 1 ; 
if fd_cat_l_ent	> 0 then logit_l_ent  = 1 ; 
if fd_cat_other	> 0 then logit_other  = 1 ; 
if fd_cat_side	> 0 then logit_side  = 1 ; 
if fd_cat_soupsal > 0 then logit_soupsal  = 1 ; 
if fd_cat_steak > 0 then logit_steak = 1;
run;


data mba_cl_2;
set tgif.final_clusters;
if cluster = 2;
logit_alcoh = 0;  logit_app  = 0 ; logit_bev  = 0 ; 
logit_brunc  = 0 ; logit_buffe  = 0 ; logit_burg  = 0 ; 
logit_combo  = 0 ; logit_dress  = 0 ; logit_drink  = 0 ; 
logit_h_ent  = 0 ; logit_kids  = 0 ; logit_l_ent  = 0 ; 
logit_other  = 0 ; logit_side  = 0 ; logit_soupsal  = 0 ; logit_steak = 0;

if fd_cat_alcoh	> 0 then logit_alcoh = 1; 
if fd_cat_app	> 0 then logit_app  = 1 ; 
if fd_cat_bev	> 0 then logit_bev  = 1 ; 
if fd_cat_brunc	> 0 then logit_brunc  = 1 ; 
if fd_cat_buffe	> 0 then logit_buffe  = 1 ; 
if fd_cat_burg	> 0 then logit_burg  = 1 ; 
if fd_cat_combo	> 0 then logit_combo  = 1 ; 
if fd_cat_dess	> 0 then logit_dress  = 1 ; 
if fd_cat_drink	> 0 then logit_drink  = 1 ; 
if fd_cat_h_ent	> 0 then logit_h_ent  = 1 ; 
if fd_cat_kids	> 0 then logit_kids  = 1 ; 
if fd_cat_l_ent	> 0 then logit_l_ent  = 1 ; 
if fd_cat_other	> 0 then logit_other  = 1 ; 
if fd_cat_side	> 0 then logit_side  = 1 ; 
if fd_cat_soupsal > 0 then logit_soupsal  = 1 ; 
if fd_cat_steak > 0 then logit_steak = 1;
run;


data mba_cl_3;
set tgif.final_clusters;
if cluster = 3;
logit_alcoh = 0;  logit_app  = 0 ; logit_bev  = 0 ; 
logit_brunc  = 0 ; logit_buffe  = 0 ; logit_burg  = 0 ; 
logit_combo  = 0 ; logit_dress  = 0 ; logit_drink  = 0 ; 
logit_h_ent  = 0 ; logit_kids  = 0 ; logit_l_ent  = 0 ; 
logit_other  = 0 ; logit_side  = 0 ; logit_soupsal  = 0 ; logit_steak = 0;

if fd_cat_alcoh	> 0 then logit_alcoh = 1; 
if fd_cat_app	> 0 then logit_app  = 1 ; 
if fd_cat_bev	> 0 then logit_bev  = 1 ; 
if fd_cat_brunc	> 0 then logit_brunc  = 1 ; 
if fd_cat_buffe	> 0 then logit_buffe  = 1 ; 
if fd_cat_burg	> 0 then logit_burg  = 1 ; 
if fd_cat_combo	> 0 then logit_combo  = 1 ; 
if fd_cat_dess	> 0 then logit_dress  = 1 ; 
if fd_cat_drink	> 0 then logit_drink  = 1 ; 
if fd_cat_h_ent	> 0 then logit_h_ent  = 1 ; 
if fd_cat_kids	> 0 then logit_kids  = 1 ; 
if fd_cat_l_ent	> 0 then logit_l_ent  = 1 ; 
if fd_cat_other	> 0 then logit_other  = 1 ; 
if fd_cat_side	> 0 then logit_side  = 1 ; 
if fd_cat_soupsal > 0 then logit_soupsal  = 1 ; 
if fd_cat_steak > 0 then logit_steak = 1;
run;



data mba_cl_4;
set tgif.final_clusters;
if cluster = 4;
logit_alcoh = 0;  logit_app  = 0 ; logit_bev  = 0 ; 
logit_brunc  = 0 ; logit_buffe  = 0 ; logit_burg  = 0 ; 
logit_combo  = 0 ; logit_dress  = 0 ; logit_drink  = 0 ; 
logit_h_ent  = 0 ; logit_kids  = 0 ; logit_l_ent  = 0 ; 
logit_other  = 0 ; logit_side  = 0 ; logit_soupsal  = 0 ; logit_steak = 0;

if fd_cat_alcoh	> 0 then logit_alcoh = 1; 
if fd_cat_app	> 0 then logit_app  = 1 ; 
if fd_cat_bev	> 0 then logit_bev  = 1 ; 
if fd_cat_brunc	> 0 then logit_brunc  = 1 ; 
if fd_cat_buffe	> 0 then logit_buffe  = 1 ; 
if fd_cat_burg	> 0 then logit_burg  = 1 ; 
if fd_cat_combo	> 0 then logit_combo  = 1 ; 
if fd_cat_dess	> 0 then logit_dress  = 1 ; 
if fd_cat_drink	> 0 then logit_drink  = 1 ; 
if fd_cat_h_ent	> 0 then logit_h_ent  = 1 ; 
if fd_cat_kids	> 0 then logit_kids  = 1 ; 
if fd_cat_l_ent	> 0 then logit_l_ent  = 1 ; 
if fd_cat_other	> 0 then logit_other  = 1 ; 
if fd_cat_side	> 0 then logit_side  = 1 ; 
if fd_cat_soupsal > 0 then logit_soupsal  = 1 ; 
if fd_cat_steak > 0 then logit_steak = 1;
run;



data mba_cl_5;
set tgif.final_clusters;
if cluster = 5;
logit_alcoh = 0;  logit_app  = 0 ; logit_bev  = 0 ; 
logit_brunc  = 0 ; logit_buffe  = 0 ; logit_burg  = 0 ; 
logit_combo  = 0 ; logit_dress  = 0 ; logit_drink  = 0 ; 
logit_h_ent  = 0 ; logit_kids  = 0 ; logit_l_ent  = 0 ; 
logit_other  = 0 ; logit_side  = 0 ; logit_soupsal  = 0 ; logit_steak = 0;

if fd_cat_alcoh	> 0 then logit_alcoh = 1; 
if fd_cat_app	> 0 then logit_app  = 1 ; 
if fd_cat_bev	> 0 then logit_bev  = 1 ; 
if fd_cat_brunc	> 0 then logit_brunc  = 1 ; 
if fd_cat_buffe	> 0 then logit_buffe  = 1 ; 
if fd_cat_burg	> 0 then logit_burg  = 1 ; 
if fd_cat_combo	> 0 then logit_combo  = 1 ; 
if fd_cat_dess	> 0 then logit_dress  = 1 ; 
if fd_cat_drink	> 0 then logit_drink  = 1 ; 
if fd_cat_h_ent	> 0 then logit_h_ent  = 1 ; 
if fd_cat_kids	> 0 then logit_kids  = 1 ; 
if fd_cat_l_ent	> 0 then logit_l_ent  = 1 ; 
if fd_cat_other	> 0 then logit_other  = 1 ; 
if fd_cat_side	> 0 then logit_side  = 1 ; 
if fd_cat_soupsal > 0 then logit_soupsal  = 1 ; 
if fd_cat_steak > 0 then logit_steak = 1;
run;


proc means data = cluster_1;
var alcohol appetizer beverage brunch buffet burger combo dessert drink h_entree kids l_entree other side soup_sal steak;
run;

/*Alcohol h_entree  appetizer*/

proc logistic descending data = mba_cl_1;
model 
logit_alcoh = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_h_ent   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc logistic descending data = mba_cl_1;
model 
logit_h_ent = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_alcoh   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc means data = cluster_2;
var alcohol appetizer beverage brunch buffet burger combo dessert drink h_entree kids l_entree other side soup_sal steak;
run;

/* h_entree alcohol   appetizer*/

proc logistic descending data = mba_cl_2;
model 
logit_alcoh = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_h_ent   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc logistic descending data = mba_cl_2;
model 
logit_h_ent = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_alcoh   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc means data = cluster_3;
var alcohol appetizer beverage brunch buffet burger combo dessert drink h_entree kids l_entree other side soup_sal steak;
run;

/* h_entree appetizer   alcohol*/

proc logistic descending data = mba_cl_3;
model 
logit_alcoh = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_h_ent   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc logistic descending data = mba_cl_3;
model 
logit_h_ent = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_alcoh   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;


proc means data = cluster_4;
var alcohol appetizer beverage brunch buffet burger combo dessert drink h_entree kids l_entree other side soup_sal steak;
run;

/* h_entree alcohol   appetizer*/

proc logistic descending data = mba_cl_4;
model 
logit_alcoh = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_h_ent   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc logistic descending data = mba_cl_4;
model 
logit_h_ent = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_alcoh   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc means data = cluster_5;
var alcohol appetizer beverage brunch buffet burger combo dessert drink h_entree kids l_entree other side soup_sal steak;
run;

/*Alcohol*/

proc logistic descending data = mba_cl_5;
model 
logit_alcoh = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_h_ent   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

proc logistic descending data = mba_cl_5;
model 
logit_h_ent = logit_app   logit_bev  logit_brunc   logit_buffe   logit_burg   logit_combo   logit_dress
logit_drink   logit_alcoh   logit_kids   logit_l_ent   
logit_other   logit_side   logit_soupsal logit_steak ; 
run;

/*
proc means data = products;
var logit_a logit_b logit_c logit_d logit_e;
run;


proc logistic descending data = products;
model logit_c = logit_a logit_b logit_d logit_e; run;
*/



proc means data = cluster_1; 
var net_amt_p_item items_tot; 
run;

proc reg data = cluster_1; 
model items_tot = email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age /VIF COLLIN; 
run;

proc means data = cluster_2; 
var net_amt_p_item items_tot; 
run;

proc reg data = cluster_2; 
model items_tot = email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age /VIF COLLIN; 
run;

proc means data = cluster_3; 
var net_amt_p_item items_tot; 
run;

proc reg data = cluster_3; 
model items_tot = email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age /VIF COLLIN; 
run;

proc means data = cluster_4; 
var net_amt_p_item items_tot; 
run;

proc reg data = cluster_4; 
model items_tot = email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age /VIF COLLIN; 
run;

proc means data = cluster_5; 
var net_amt_p_item items_tot; 
run;

proc reg data = cluster_5; 
model items_tot = email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age /VIF COLLIN; 
run;





















/* -------------------------------------------------------------- */




proc discrim data= work.final out=output scores = x method=normal anova;
   class cluster ;
   priors prop;
   id customer_number;
   var  

email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age ;

run;


proc sort data = final; by cluster; run;


proc means data = work.final; by cluster; 
output out = means; run;




/* Draft Work */

proc means data = tgif.tgif_copy;
var age;
where age > 4;
run;

/*
proc cluster data = tgif.tgif_copy noprint
method = average std pseudo noeigen outtree = tree;

var 
email_send	disc_pct_tot	net_sales_tot	days_between_trans	tenure_day	guests_last_12mo;

id customer_number; run;
*/


proc sql;
create table tgif.tgif_clean
as
select 
points_ratio,email_send,email_open_rate,email_click_rate,email_forward_rate,email_send*email_open_rate as email_open, email_send*email_click_rate as email_click,email_send*email_forward_rate as email_forward,rest_loc_bar,rest_loc_Merch,rest_loc_Open,rest_loc_Patio,rest_loc_Rest,rest_loc_rm_serv,rest_loc_Take_out,rest_loc_cafe,rest_loc_unkn,time_breakfast,time_dinner,time_late_nite,time_lunch,time_unknown,disc_app,disc_beverage,disc_dessert,disc_employee,disc_food,disc_other,disc_ribs,disc_sandwich,disc_ticket,disc_type_bogo,disc_type_comp,disc_type_dolfood,disc_type_empl,disc_type_free,disc_type_other,disc_type_pctfood,disc_chan_advo,disc_chan_comp,disc_chan_demo,disc_chan_empl,disc_chan_entbk,disc_chan_gmms,disc_chan_gps,disc_chan_laten,disc_chan_local,disc_chan_other,disc_chan_part,disc_chan_smart,disc_chan_valc,disc_chan_value,disc_pct_tot,disc_pct_trans,items_tot_distinct,items_tot,net_amt_p_item,checks_tot,net_sales_p_chck,net_sales_tot,
fd_cat_alcoh*net_sales_tot as alcohol,fd_cat_app*net_sales_tot as appetizer,fd_cat_bev*net_sales_tot as beverage,fd_cat_brunc*net_sales_tot as brunch,fd_cat_buffe*net_sales_tot as buffet,fd_cat_burg*net_sales_tot as burger,fd_cat_combo*net_sales_tot as combo,fd_cat_dess*net_sales_tot as dessert,fd_cat_drink*net_sales_tot as drink,fd_cat_h_ent*net_sales_tot as h_entree,fd_cat_kids*net_sales_tot as kids,fd_cat_l_ent*net_sales_tot as l_entree,fd_cat_other*net_sales_tot as other,fd_cat_side*net_sales_tot as side,fd_cat_soupsal*net_sales_tot as soup_sal,fd_cat_steak*net_sales_tot as steak,
/*fd_cat_alcoh,fd_cat_app,fd_cat_bev,fd_cat_brunc,fd_cat_buffe,fd_cat_burg,fd_cat_combo,fd_cat_dess,fd_cat_drink,fd_cat_h_ent,fd_cat_kids,fd_cat_l_ent,fd_cat_other,fd_cat_side,fd_cat_soupsal,fd_cat_steak,*/
days_between_trans,tenure_day,age,guests_last_12mo,customer_number
from tgif.tgif_copy
/*where age > 0*/;
run;

PROC SORT DATA = tgif.tgif_clean;  BY customer_number; RUN;


PROC STANDARD DATA= tgif.tgif_clean MEAN=0 STD=1 OUT= tgif.scaled;
/*var email_send	disc_pct_tot	net_sales_tot	days_between_trans	tenure_day	guests_last_12mo
fd_cat_alcoh	fd_cat_app	fd_cat_bev	fd_cat_brunc	fd_cat_buffe	fd_cat_burg	fd_cat_combo	
fd_cat_dess	fd_cat_drink	fd_cat_h_ent	fd_cat_kids	fd_cat_l_ent	fd_cat_other	fd_cat_side	fd_cat_soupsal	fd_cat_steak;*/
RUN;


proc corr data = tgif.scaled;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age 
    alcohol  appetizer  beverage buffet  burger  drink  h_entree  kids  l_entree  other  side  soup_sal  steak;

run;

proc fastclus data= tgif.tgif_clean maxc= 8 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;



proc fastclus data= tgif.tgif_clean maxc= 2 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= tgif.tgif_clean maxc= 3 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= tgif.tgif_clean maxc= 4 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= tgif.tgif_clean maxc= 5 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= tgif.tgif_clean maxc= 6 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= tgif.tgif_clean maxc= 7 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= tgif.tgif_clean maxc= 8 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;


proc fastclus data= tgif.tgif_clean maxc= 9 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;


proc fastclus data= tgif.tgif_clean maxc= 10 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;


proc fastclus data= tgif.tgif_clean maxc= 11 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;


proc fastclus data= tgif.tgif_clean maxc= 12 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;




proc fastclus data= tgif.scaled maxc= 3 maxiter=10 out=resultscaled3;
var email_send	disc_pct_tot	net_sales_tot	days_between_trans	tenure_day	guests_last_12mo;
run;


proc fastclus data= tgif.scaled maxc= 4 maxiter=10 out=resultscaled4;
var email_send	disc_pct_tot	net_sales_tot	days_between_trans	tenure_day	guests_last_12mo;
run;


proc fastclus data= tgif.tgif_clean maxc= 5 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;


proc fastclus data= tgif.tgif_clean maxc= 5 out=resultscaled5;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age
    alcohol  appetizer  beverage buffet  burger  drink  h_entree  kids  l_entree  other  side  soup_sal  steak;
run;


proc fastclus data= tgif.scaled maxc= 6 maxiter=10 out=resultscaled6;
var email_send	disc_pct_tot	net_sales_tot	days_between_trans	tenure_day	guests_last_12mo;
run;

proc fastclus data= tgif.scaled maxc= 7 maxiter=10 out=resultscaled6;
var email_send	disc_pct_tot	net_sales_tot	days_between_trans	tenure_day	guests_last_12mo;
run;








proc fastclus data= tgif.tgif_clean maxc= 3 maxiter=10 out=result3;
run;


proc fastclus data= tgif.tgif_clean maxc= 4 maxiter=10 out=result4;
run;


proc fastclus data= tgif.tgif_clean maxc= 5 maxiter=10 out=result5;
run;


proc fastclus data= tgif.tgif_clean maxc= 6 maxiter=10 out=result6;
run;


proc fastclus data= tgif.tgif_clean maxc= 7 maxiter=10 out=result7;
run;

proc sql;
select count(*) from tgif.tgif_copy
/*where age < 10*/;
run;


/*
points_ratio,email_send,email_open_rate,email_click_rate,email_forward_rate,email_send*email_open_rate as email_open, email_send*email_click_rate as email_click,email_send*email_forward_rate as email_forward,rest_loc_bar,rest_loc_Merch,rest_loc_Open,rest_loc_Patio,rest_loc_Rest,rest_loc_rm_serv,rest_loc_Take_out,rest_loc_cafe,rest_loc_unkn,time_breakfast,time_dinner,time_late_nite,time_lunch,time_unknown,disc_app,disc_beverage,disc_dessert,disc_employee,disc_food,disc_other,disc_ribs,disc_sandwich,disc_ticket,disc_type_bogo,disc_type_comp,disc_type_dolfood,disc_type_empl,disc_type_free,disc_type_other,disc_type_pctfood,disc_chan_advo,disc_chan_comp,disc_chan_demo,disc_chan_empl,disc_chan_entbk,disc_chan_gmms,disc_chan_gps,disc_chan_laten,disc_chan_local,disc_chan_other,disc_chan_part,disc_chan_smart,disc_chan_valc,disc_chan_value,disc_pct_tot,disc_pct_trans,items_tot_distinct,items_tot,net_amt_p_item,checks_tot,net_sales_p_chck,net_sales_tot,fd_cat_alcoh,fd_cat_app,fd_cat_bev,fd_cat_brunc,fd_cat_buffe,fd_cat_burg,fd_cat_combo,fd_cat_dess,fd_cat_drink,fd_cat_h_ent,fd_cat_kids,fd_cat_l_ent,fd_cat_other,fd_cat_side,fd_cat_soupsal,fd_cat_steak,days_between_trans,tenure_day,age,guests_last_12mo,customer_number
*/


/*
points_ratio,email_send,email_open_rate,email_click_rate,email_forward_rate,email_send*email_open_rate as email_open, email_send*email_click_rate as email_click,email_send*email_forward_rate as email_forward,rest_loc_bar,rest_loc_Merch,rest_loc_Open,rest_loc_Patio,rest_loc_Rest,rest_loc_rm_serv,rest_loc_Take_out,rest_loc_cafe,rest_loc_unkn,time_breakfast,time_dinner,time_late_nite,time_lunch,time_unknown,disc_app,disc_beverage,disc_dessert,disc_employee,disc_food,disc_other,disc_ribs,disc_sandwich,disc_ticket,disc_type_bogo,disc_type_comp,disc_type_dolfood,disc_type_empl,disc_type_free,disc_type_other,disc_type_pctfood,disc_chan_advo,disc_chan_comp,disc_chan_demo,disc_chan_empl,disc_chan_entbk,disc_chan_gmms,disc_chan_gps,disc_chan_laten,disc_chan_local,disc_chan_other,disc_chan_part,disc_chan_smart,disc_chan_valc,disc_chan_value,disc_pct_tot,disc_pct_trans,items_tot_distinct,items_tot,net_amt_p_item,checks_tot,net_sales_p_chck,net_sales_tot,
fd_cat_alcoh*net_sales_tot as alcohol,fd_cat_app*net_sales_tot as appetizer,fd_cat_bev*net_sales_tot as beverage,fd_cat_brunc*net_sales_tot as brunch,fd_cat_buffe*net_sales_tot as buffet,fd_cat_burg*net_sales_tot as burger,fd_cat_combo*net_sales_tot as combo,fd_cat_dess*net_sales_tot as dessert,fd_cat_drink*net_sales_tot as drink,fd_cat_h_ent*net_sales_tot as h_entree,fd_cat_kids*net_sales_tot as kids,fd_cat_l_ent*net_sales_tot as l_entree,fd_cat_other*net_sales_tot as other,fd_cat_side*net_sales_tot as side,fd_cat_soupsal*net_sales_tot as soup_sal,fd_cat_steak*net_sales_tot as steak,
fd_cat_alcoh,fd_cat_app,fd_cat_bev,fd_cat_brunc,fd_cat_buffe,fd_cat_burg,fd_cat_combo,fd_cat_dess,fd_cat_drink,fd_cat_h_ent,fd_cat_kids,fd_cat_l_ent,fd_cat_other,fd_cat_side,fd_cat_soupsal,fd_cat_steak,
days_between_trans,tenure_day,age,guests_last_12mo,customer_number
*/



/**/

LIBNAME TGIF 'C:\Users\DOMINIC\Documents\MKT6337\TGIF'; 
run;

data tgif_copy;
set tgif.tgif;
run;

proc sql;
create table tgif_clean
as
select * from tgif_copy
where disc_pct_tot<= 1
and net_sales_tot >= net_amt_p_item;

proc means data = tgif.tgif_clean;
var age;
where age > 4;
run;

data tgif_impute;
set tgif_clean;
if age <= 4 then age = 47;
run;


PROC SORT DATA = tgif_impute;  BY customer_number; RUN;


PROC STANDARD DATA= tgif_impute MEAN=0 STD=1 OUT= standard;
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
RUN;

proc sql ;
create table standard_filtered
as
select * from standard
where net_amt_p_item <= 8;
run;




proc fastclus data= standard_filtered maxc= 4 out= clus_final (keep = customer_number cluster);
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= standard_filtered maxc= 5 out= clus_final (keep = customer_number cluster);
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= standard_filtered maxc= 6 out= clus_final (keep = customer_number cluster);
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= standard_filtered maxc= 7 out= clus_final (keep = customer_number cluster);
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= standard_filtered maxc= 8 out= clus_final (keep = customer_number cluster);
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

proc fastclus data= standard_filtered maxc= 9 out= clus_final (keep = customer_number cluster);
var email_send	disc_pct_tot  net_amt_p_item	days_between_trans	tenure_day	age;
run;

