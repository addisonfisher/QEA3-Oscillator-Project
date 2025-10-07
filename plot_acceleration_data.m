function plot_acceleration_data()
    filename = "data.csv";
    data = readtable(filename);

    time_column = data{280:end, 1}; %first column for time
    acceleration_column = data{280:end, 2}; %second column for acceleration
    figure;

    %acceleration data vs. time
    hold on;
    plot(time_column, acceleration_column, 'LineWidth', 1.5);

    xlabel('Time (s)');
    ylabel('Acceleration (Y)(m/s^2)');
    title('Time vs. Acceleration');
    grid on;
end