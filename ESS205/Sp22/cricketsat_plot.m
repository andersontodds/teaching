% cricketsat_plot.m
% Todd Anderson
% May 4, 2022
%
% Plot CricketSat frequency measurements, estimate temperature from
% calibration curves.

%% Select flight

section = "A"; %OPTIONS: "A", "B"

%% Import CricketSat data:

filename = sprintf("2022_CK%s.txt",section);

crickdata = importdata(filename,' ');
%crickdata = importdata('2022_CKB.txt',' ');

time = crickdata(:,1);
freq = crickdata(:,2);

if section == "A"
    start_time = datetime(2022,05,03,13,46,01);
    launch_time= datetime(2022,05,03,13,50,00);
    cloud_time = datetime(2022,05,03,13,55,00);

else
    start_time = datetime(2022,05,03,15,28,01);
    launch_time= datetime(2022,05,03,15,29,00);
    cloud_time = datetime(2022,05,03,15,35,00);
end

launch_s = seconds(launch_time - start_time);
cloud_s = seconds(cloud_time - start_time);



%% 1. Plot frequency vs. time
figure(1)
hold off
plot(time, freq, '.');
hold on
xline(launch_s, 'r');
xline(cloud_s,  'b');
xlabel('time (s)');
ylabel('frequency (Hz)');
titlestr = sprintf("CricketSat frequency - A%s section",section);
title(titlestr);
%title('CricketSat frequency - AB section');


%% 2. Plot frequency vs. time with outliers removed

% outlier removal by inspection
if section == "A"
    freq_bad = freq < 390;
    time_bad = time > 1300;
    tf_bad = 0;             % not used
else
    freq_bad = freq < 385;
    time_bad = time > 1470;
    tf_bad = time > 1000 & freq < 410;
end

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
%plot(time, ones(size(time)).*C);
plot(time, ones(size(time)).*U);
xline(launch_s, 'r');
xline(cloud_s,  'b');
ylim([0 600]);
legend('raw data', 'outliers (from 3 MAD)', 'outliers (by inspection)', 'outlier filter lower limit', 'outlier filter upper limit');

figure(2)
hold off
plot(time_clean, freq_clean, '.');
hold on
xline(launch_s, 'r');
xline(cloud_s,  'b');
xlabel('time (s)');
ylabel('frequency (Hz)');
title(titlestr);
%title('CricketSat frequency - AB section');
ylim([0 600]);

%% 3. Estimate temperature using the CricketSat calibration curve

if section == "A"
    %temp_clean = 3776./(log(1./freq_clean - 1/2498) + 19.70) - 273.2;
    A = 3376;
    B = 2498;
    C = 19.70;
    D = 273.2;

else
    %temp_clean = 3801./(log(1./freq_clean - 1/2539) + 19.73) - 273.2;
    A = 3801;
    B = 2539;
    C = 19.73;
    D = 273.2;
end

temp_clean = A./(log(1./freq_clean - 1/B) + C) - D;

figure(3)
hold off;
plot(time_clean, temp_clean, '.');
hold on;
xline(launch_s, 'r');
xline(cloud_s,  'b');
xlabel('time (s)');
ylabel('temperature (C)');
titlestr = sprintf("CricketSat temperature - A%s section",section);
title(titlestr);
%title('CricketSat temperature - AB section');

