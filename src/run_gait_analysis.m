clear; clc; close all;

%% === 1. Load and process digitized data ===
filename = 'DLTdv8_data_final_adjustedy_xypts.csv'; % Update filename as needed

% Check file existence
if ~isfile(filename)
    error('File not found: %s', filename);
end

data = importdata(filename).data;

% Extract relevant marker coordinates (adjust if data columns differ)
pointer_x = data(:,1);
pointer_y = data(:,2);
outer_leg_x = data(:,3);
outer_leg_y = data(:,4);
rod_x = data(:,5);
rod_y = data(:,6);

% Pixel calibration points
pixel_calib_x1 = data(1,7);
pixel_calib_y1 = data(1,8);
pixel_calib_x2 = data(2,7);
pixel_calib_y2 = data(2,8);

% Constants
frame_rate = 60;           % Frames per second
time_step = 1/frame_rate;  % Time between frames (s)
mass = 0.025;              % Mass (kg)
ramp_angle = 4;            % Ramp angle in degrees
calib_length = 0.04;       % Calibration length in meters

% Compute pixel size (meters per pixel)
pixel_length = calib_length / sqrt((pixel_calib_x2-pixel_calib_x1)^2 + (pixel_calib_y2-pixel_calib_y1)^2);

% Ramp vector & perpendicular vector for stance angle calc
ramp = [pixel_calib_x2 - pixel_calib_x1; pixel_calib_y2 - pixel_calib_y1];
perp_ramp = [ramp(2); -ramp(1)]; % Perpendicular vector
perp_ramp_array = repmat(perp_ramp', length(pointer_x), 1);

%% === 2. Compute angles and time vectors ===
interleg_angles = calculateAngles3(pointer_x, pointer_y, rod_x, rod_y, outer_leg_x, outer_leg_y);
stance_angles = calculateAngles4(rod_x, rod_y, outer_leg_x, outer_leg_y, perp_ramp_array);

interleg_angles_abs = abs(interleg_angles);
stance_angles_abs = abs(stance_angles);

time = (0:time_step:time_step*(length(interleg_angles)-1))';               % Absolute time (s)
non_dim_time = time / max(time);                                            % Non-dimensional time [0,1]

%% === 3. Plot leg angles vs absolute and non-dimensional time ===
figure('Name','Leg Angles over Time','Color','w');
hold on; grid on;
plot(time, interleg_angles_abs, 'r-', 'DisplayName', 'Abs Interleg Angle');
plot(time, stance_angles, 'b-', 'DisplayName', 'Stance Angle');
xlabel('Time (s)', 'FontSize', 12);
ylabel('Angle (deg)', 'FontSize', 12);
legend('Location','northwest');
title('Leg Angles vs Absolute Time');

% Second x-axis for non-dimensional time
ax1 = gca;
ax2 = axes('Position', ax1.Position, 'XAxisLocation', 'top', 'Color', 'none');
ax2.XLim = [0 1];
ax2.XTick = 0:0.2:1;
ax2.XTickLabel = round(linspace(0, max(time), 6),2);
ax2.YTick = [];
xlabel(ax2, 'Non-dimensional Time');
hold off;

%% === 4. Plot interleg angle vs stance angle for multiple steps ===
% Define step segmentation indices (update based on data)
step_bounds = [1, 44, 56, 72, 91, length(stance_angles)];

colors = lines(length(step_bounds)-1);
figure('Name', 'Interleg vs Stance Angle (Multiple Steps)', 'Color', 'w'); hold on; grid on;

for i = 1:length(step_bounds)-1
    idx_range = step_bounds(i):step_bounds(i+1)-1;
    scatter(stance_angles(idx_range), interleg_angles_abs(idx_range), 36, colors(i,:), 'filled', 'HandleVisibility','off');
    plot(stance_angles(idx_range), interleg_angles_abs(idx_range), 'Color', colors(i,:), 'DisplayName', sprintf('Step %d', i));
end

xlabel('Stance Angle (deg)', 'FontSize', 12);
ylabel('Absolute Interleg Angle (deg)', 'FontSize', 12);
title('Interleg Angle as a Function of Stance Angle over Multiple Steps');
legend('Location','best');
hold off;

%% === 5. Estimate center of mass (CoM) trajectories ===
traj_x = -(rod_x - rod_x(1)) * pixel_length;  % Convert pixels to meters and relative to initial
traj_y = -(rod_y - rod_y(1)) * pixel_length;

figure('Name', 'CoM Trajectories', 'Color', 'w');
subplot(2,1,1);
plot(time, traj_x * 1000, 'k-'); % Convert to mm
xlabel('Time (s)'); ylabel('Horizontal Displacement (mm)');
title('Horizontal CoM Trajectory'); grid on;

subplot(2,1,2);
plot(time, traj_y * 1000, 'k-');
xlabel('Time (s)'); ylabel('Vertical Displacement (mm)');
title('Vertical CoM Trajectory'); grid on;

%% === 6. Compute potential and kinetic energy ===
v_x = diff(traj_x) ./ diff(time);
v_y = diff(traj_y) ./ diff(time);
v = sqrt(v_x.^2 + v_y.^2);

KE = 0.5 * mass * v.^2;  % Kinetic energy (J)

% Detrended vertical displacement corrected for ramp slope
traj_y_detrended = traj_y + traj_x .* tan(deg2rad(ramp_angle));
PE = mass * 9.81 * traj_y_detrended(1:end-1); % Potential energy (J), align size with KE

figure('Name','Energy Dynamics','Color','w');
hold on; grid on;
plot(time(1:end-1), KE, 'r-', 'DisplayName', 'Kinetic Energy');
plot(time(1:end-1), PE, 'b-', 'DisplayName', 'Potential Energy');
xlabel('Time (s)');
ylabel('Energy (J)');
title('Kinetic and Potential Energy of the Passive Dynamic Walker');
legend('Location','best');
hold off;

%% === 7. Interpretation: Is the robot walking or limping? ===
% This requires visual/manual assessment based on the plots.
% You can add comments in your report about gait symmetry, consistency,
% and presence of irregularities in angle trajectories or energy fluctuations.

disp('--- Gait Interpretation ---');
disp('Review the plots:');
disp('1. Are interleg and stance angles periodic and smooth?');
disp('2. Are energy fluctuations stable and rhythmic?');
disp('3. Does the CoM trajectory show consistent forward progression?');
disp('Answer these questions to determine walking vs limping.');



%% === Helper functions ===

function angles = calculateAngles3(xA, yA, xB, yB, xC, yC)
    % Calculates angle at point B formed by points A-B-C
    AB = [xB - xA, yB - yA];
    BC = [xB - xC, yB - yC];
    angle_rad = atan2(AB(:,1).*BC(:,2) - AB(:,2).*BC(:,1), AB(:,1).*BC(:,1) + AB(:,2).*BC(:,2));
    angles = rad2deg(angle_rad);
end

function angles = calculateAngles4(xA, yA, xB, yB, CD)
    % Calculates angle between vector AB and vector CD
    AB = [xB - xA, yB - yA];
    angle_rad = atan2(AB(:,1).*CD(:,2) - AB(:,2).*CD(:,1), AB(:,1).*CD(:,1) + AB(:,2).*CD(:,2));
    angle_rad_adjusted = angle_rad + pi;
    angle_rad_adjusted(angle_rad_adjusted > pi) = angle_rad_adjusted(angle_rad_adjusted > pi) - 2*pi;
    angles = rad2deg(angle_rad_adjusted);
end
