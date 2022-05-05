% classBalloonData.m
%
% load and plot data, interpolation demos, etc
%
% use importdata to load data without header lines
%   GPS files have 1 header line, EXP files have 2 header lines

delimiterIn = ' ';
gpsH = 1;
expH = 2;

% load GPS file and get individual vectors
balloonAGPS = importdata('2017BalloonA_gps.txt', delimiterIn, gpsH);

gps_time_A = str2double(balloonAGPS.textdata(2:end,1));
lat_A = balloonAGPS.data(:,1);
lon_A = balloonAGPS.data(:,2);
alt_A = balloonAGPS.data(:,3);

% load EXP file and get individual vectors
balloonAEXP = importdata('2017BalloonA_exp.txt', delimiterIn, expH);

exp_time_A = balloonAEXP.data(:,1);

alt_exp = interp1(gps_time_A, alt_A, exp_time_A);

%%

%plot everything
figure(1);
plot(gps_time_A, alt_A, 'o');
title('Altitude vs Time (GPS)');
xlabel('Time (s)');
ylabel('Altitude (km)');

hold off;

%%

figure(2);
% add vertical lines at exp times
hold on;

for i = 1:length(exp_time_A)
    line([exp_time_A(i) exp_time_A(i)],[min(alt_A), max(alt_A)],'Color', 'red');
end

plot(gps_time_A, alt_A, 'o');
title('Altitude vs Time');
xlabel('Time (s)');
ylabel('Altitude (km)');

hold off;

%%

figure(3);
% plot interpolated altitude at exp times
hold on;

for i = 1:length(exp_time_A)
    line([exp_time_A(i) exp_time_A(i)],[min(alt_A), max(alt_A)],'Color', 'red');
end

plot(gps_time_A, alt_A, 'o');
plot(exp_time_A, alt_exp, 'o');
title('Altitude vs Time');
xlabel('Time (s)');
ylabel('Altitude (km)');
legend('Altitude at GPS time', 'Altitude at EXP time');

hold off;

%%
% plot altitude fit function

p1 = 3.614E-7;
p2 = 0.004782;
p3 = -4.081;

time = exp_time_A;

%altfit = zeros(size(exp_time_A));

altfit = p1.*time.^2 + p2.*time + p3;

figure(4)
plot(time, altfit);
hold on;

for i = 1:length(exp_time_A)
    line([exp_time_A(i) exp_time_A(i)],[min(alt_A), max(alt_A)],'Color', 'red');
end

plot(gps_time_A, alt_A, 'o');
plot(exp_time_A, alt_exp, 'o');
title('Altitude vs Time');
xlabel('Time (s)');
ylabel('Altitude (km)');
legend('Altitude at GPS time', 'Altitude at EXP time');

hold off;
