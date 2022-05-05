% cricketsat_plot.m
% Todd Anderson
% May 4, 2022
%
% Plot CricketSat frequency measurements, estimate temperature from
% calibration curves.

%% Import CricketSat data:

crickdata = importdata('2022_CKA.txt',' ');
%crickdata = importdata('2022_CKB.txt',' ');

time = crickdata(:,1);
freq = crickdata(:,2);

%% 1. Plot frequency vs. time
figure(1)
hold off
plot(time, freq, '.');
xlabel('time (s)');
ylabel('frequency (Hz)');
title('CricketSat frequency - AA section');
%title('CricketSat frequency - AB section');


%% 2. Plot frequency vs. time with outliers removed

% outlier removal by inspection
%freq(freq < 390) = NaN;
%freq(time > 1300) = NaN;
tf_bad = [];
%freq_bad = freq < 385;
%time_bad = time > 1470;
%tf_bad = time > 1000 & freq < 410;
bad_ind = freq_bad | time_bad | tf_bad;

% outlier removal by algorithm
[out_ind, L, U, C] = isoutlier(freq, 'movmedian', 100);

time_clean = time(~bad_ind & ~out_ind);
freq_clean = freq(~bad_ind & ~out_ind);

figure(1);
hold on;
plot(time(out_ind), freq(out_ind), 'r*');
plot(time(bad_ind), freq(bad_ind), 'mo');
plot(time, ones(size(time)).*L);
plot(time, ones(size(time)).*C);
plot(time, ones(size(time)).*U);
ylim([0 600]);

%legend('raw data', 'outliers')

figure(2)
hold off
plot(time_clean, freq_clean, '.');
xlabel('time (s)');
ylabel('frequency (Hz)');
title('CricketSat frequency - AA section');
%title('CricketSat frequency - AB section');
ylim([0 600]);

%% 3. Estimate temperature using the CricketSat calibration curve

temp_clean = 3776./(log(1./freq_clean - 1/2498) + 19.70) - 273.2;
%temp_clean = 3801./(log(1./freq_clean - 1/2539) + 19.73) - 273.2;

figure(3)
hold off;
plot(time_clean, temp_clean, '.');
xlabel('time (s)');
ylabel('temperature (C)');
title('CricketSat temperature - AA section');
title('CricketSat temperature - AB section');

