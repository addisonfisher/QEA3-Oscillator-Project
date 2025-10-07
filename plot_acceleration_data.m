function plot_acceleration_data()
    filename = "data.csv";
    data = readtable(filename);

    time_column = data.Time_s_;
    acceleration_column = data.LinearAccelerationZ_m_s_2_; % Change this to plot y or z acceleration
    figure;

    %acceleration data vs. time
    plot(time_column, acceleration_column, 'LineWidth', 1.5);

    xlabel('Time (s)');
    ylabel('Linear Acceleration (m/s^2)');
    title('Time vs. Linear Acceleration');
    grid on;
end