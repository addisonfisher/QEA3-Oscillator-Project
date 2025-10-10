function oscillator()
    mass = 0.748; %mass in kg
    k = 14.22; %spring constant

    filename = "data.csv";
    data = readtable(filename);

    acceleration = data.LinearAccelerationY_m_s_2_(280:end); %change this to plot y or z acceleration
    time = data.Time_s_(280:end);
    
    [pks, locs_index] = findpeaks(acceleration, ...
        'MinPeakProminence', 0.8, 'MinPeakDistance', 64);

    peak_times = time(locs_index);


    %delta value
    delta = mean(diff(peak_times)); 

    %omega_d (dampened natural frequency)
    omega_d = (2*pi)/delta;

    %decay rate (sigma): fitting a line
    p = polyfit(peak_times, log(pks), 1);
    sigma = -p(1); %slope is -sigma

    %omega_n (natural frequency)
    omega_n = sqrt(omega_d^2 + sigma^2);

    %zeta (damping ratio)
    zeta = sigma / omega_n;

    %amplitude
    time_first_peak = peak_times(1);
    A = exp(p(2)); % The y-intercept from polyfit is ln(A)

    %phi (phase): cosine term should be 1 at first peak
    phi = mod(omega_d * time_first_peak, 2*pi);

    %calculate the damped oscillation
    fit_accel = @(t) A * exp(-sigma * t) .* cos(omega_d * t - phi);

    %damping coefficient
    c = 2 * sqrt(14.22 * 0.748) * zeta;

    figure();
    hold on;

    plot(time, fit_accel(time), 'r-', 'LineWidth', 2, 'DisplayName', 'Fitted Analytic Solution');
    plot(time, acceleration, 'b-', 'DisplayName', 'Experimental Data');
    
    title('Experimental Data vs. Analytic Solution');
    xlabel('Time (s)');
    ylabel('Acceleration (m/s^2)');
    legend('show');
    grid on;
    hold off;


    %complex coefficients
    figure();
    plot(-sigma, omega_d, 'r.', 'MarkerSize', 20);
    hold on;
    plot(-sigma, -omega_d, 'b.', 'MarkerSize', 20);
    xlim([-2.5, 2.5]);
    ylim([-10, 10]);
    title('Complex Exponential Coefficients')
    grid on;
    plot(xlim, [0 0], 'k--', 'LineWidth', 1);
    plot([0 0], ylim, 'k--', 'LineWidth', 1);

    legend("\lambda_1", "\lambda_2", "x-axis", "y-axis")

    hold off;

    
    fprintf('System Parameters\n');
    fprintf('Moving Mass (kg): %.4f\n', mass);
    fprintf('Damping Coefficient (c): %.4f\n', c);
    fprintf('Exponential decay rate (sigma): %.4f\n', sigma);
    fprintf('Damped Frequency (omega_d): %.4f rad/s\n', omega_d);
    fprintf('Natural Frequency (omega_n): %.4f rad/s\n', omega_n);
    fprintf('Damping Ratio (zeta): %.4f\n', zeta);
end