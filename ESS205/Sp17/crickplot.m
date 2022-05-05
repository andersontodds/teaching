% crickplot.m
%
% Plot cricketsat data and determine fitting
%
% Fit function of form:
%
%   T(f) = a + b Log[f] + c (Log[f])^2 + d (Log[f])^3
%
% crickdata.mat has all cricketsat calibration data
%
% |temp set (C) | temp read (C)|  channel| current (mA)| f_osc (Hz)|
%
% channel:  1   last year's test cricketsat
%           2   KLDAR (AB)
%           3   Strato-Box (AA)
%           4   JMALG's Flare (AA)

load crickdata.mat;

crick1 = find(crickdata(:,3) == 1);
crick1data = crickdata(crick1,:);

crick2 = find(crickdata(:,3) == 2);
crick2data = crickdata(crick2,:);

crick3 = find(crickdata(:,3) == 3);
crick3data = crickdata(crick3,:);

crick4 = find(crickdata(:,3) == 4);
crick4data = crickdata(crick4,:);

plot(crick2data(:,5),crick2data(:,2),'.', crick3data(:,5),crick3data(:,2),'.', ...
    crick4data(:,5),crick4data(:,2),'.');
xlabel('Frequency (Hz)');
ylabel('Temperature (C)');
legend('KLDAR', 'Strato-Box', 'JMALGs Flare');

% fit
%
% T (degrees C) = 3833/(Log(1/f - 1/2476) + 20.07) - 273.2

flightdata = load('crick_09May2017AA.txt');

time = flightdata(:,1);
freq = flightdata(:,2);

temp = 3833./(log(1./freq - 1/2476) + 20.07) - 273.2;

%%

figure(2);
plot(time, freq);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Frequency vs Time');

figure(3);
plot(time, temp);
xlabel('Time (s)');
ylabel('Temperature (degrees C)');
title('Temperature vs Time');

%%

% remove outliers

% remove data below lowest physical temperature (~1 C)

outliers = find(temp < 1.00);

temp_clean = temp;
temp_clean(outliers) = [];
time_clean = time;
time_clean(outliers) = [];

figure(4);
plot(time_clean, temp_clean);
xlabel('Time (s)');
ylabel('Temperature (degrees C)');
title('Temperature vs Time (temp < 1 C removed)');

%%

time_cleaner = time_clean;
temp_cleaner = temp_clean;

outI = [];
for i = 2:length(temp_clean)-1

    if(abs(temp_clean(i) - temp_clean(i-1)) > 1 || abs(temp_clean(i) - temp_clean(i+1)) > 1)
        outI = [outI; i];
    end
    
end

time_cleaner(outI) = [];
temp_cleaner(outI) = [];

figure(5);
plot(time_cleaner, temp_cleaner);
xlabel('Time (s)');
ylabel('Temperature (degrees C)');
title('Temperature vs Time (Dtemp > 1 C removed)');

%%

% cleanest method: iterate for loop until all outliers are gone

time_cleanest = time;
temp_cleanest = temp;

for j = 1:10
    
    outJ = [];
    
    for i = 2:length(temp_cleanest)-1
        
        if(abs(temp_cleanest(i) - temp_cleanest(i-1)) > 1 || abs(temp_cleanest(i) - temp_cleanest(i+1)) > 1)
            outJ = [outJ; i];
        end
        
    end
    
    time_cleanest(outJ) = [];
    temp_cleanest(outJ) = [];
    
end

figure(6);

plot(time_cleanest, temp_cleanest);
xlabel('Time (s)');
ylabel('Temperature (degrees C)');
title(sprintf('Temperature vs Time (Dtemp > 5 C removed, iter = %d)',j));

%%

out_cleanest = find(temp_cleanest < 1.00);

temp_cleanest(out_cleanest) = [];
time_cleanest(out_cleanest) = [];

figure(7);
plot(time_cleanest, temp_cleanest);
xlabel('Time (s)');
ylabel('Temperature (degrees C)');
title(sprintf('Temperature vs Time (Dtemp > 5 C removed, iter = %d, temp < 1 C removed)',j));
