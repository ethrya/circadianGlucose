%% Dose response curve for HGP
% Uses data from a number of different studies and protocols. Need to
% better understand thes protocols.

% Campbell et al (1998) Fig 1
campbell = [8.846236327438668, 71.42857142857143;
41.64327352211947, 20.535714285714278;
98.58964964922463, 6.249999999999986;
1888.8395313735557, 2.232142857142847];

% Basu (2004) (note that this is EGP)
basu = [150 6.746987951807229;
    350 4.216867469879519;
    700 4.0361445783132535];

fernannini = [0.5403030968592191, 72.5587524708983;
8.217658686580279, 24.395343729409163;
21.244234570612775, 15.167142543377977;
37.81792224906654, 2.67076652756424;
72.02943114430045, 0.6975620470019663];

% Rizza (1981) Note that this is used to fit f1 in original paper
rizza = [12.554310424342344, 2.021630456417559;
27.74332752830766, 0.7579654892594125;
55.39509648429487, 0.03043038904965334;
98.97331606888534, -0.0006124355028860329;
206.62037322894446, 0.013167363312051261;
652.9566585223614, 0.01741613461332392];

% Our assumptions about height/weight
height = 1.75;
weight= 90;
%% Compile data into one array
allData = [campbell(:,1), campbell(:,2)*height;
        %basu(:,1)/6.9, basu(:,2)*.18*weight;
        fernannini(:,1)+10, fernannini(:,2)*height;
        rizza(:,1), rizza(:,2)*weight];
%% Plot (and convert data to common scale)
hold on
plot(campbell(:,1), campbell(:,2)*height,'.')
plot(basu(:,1)/6.9, basu(:,2)*.18*weight,'.')
plot(fernannini(:,1)+10, fernannini(:,2)*height,'.')
plot(rizza(:,1), rizza(:,2)*weight,'.')

const = models.constants;
I = 1:100000;
plot(I/3, models.funcs.f5(I, const))
const.C5 = 18.6; const.Rm = 181.5; const.alpha = 0.1168;
plot(I/3, models.funcs.f5(I, const))
set(gca, 'XScale', 'log')
legend('Campbell', 'Basu', 'Fernanni', 'Rizza', 'Original f_5', 'New f_5')
hold off