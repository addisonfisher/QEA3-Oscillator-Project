function oscillator()
    %car + phone = 748g
    filename = "data.csv";
    data = readtable(filename);

    acceleration = data.LinearAccelerationY_m_s_2_(280:end); %change this to plot y or z acceleration
    time = data.Time_s_(280:end);
    
    %find peaks for delta/zeta
    peak1 = max(acceleration(80:90));
    peak2 = max(acceleration(170:180));
    
    time_peak1 = time(find(acceleration(80:90) == peak1, 1) + 79);
    time_peak2 = time(find(acceleration(170:180) == peak2, 1) + 169);

    time_delta = time_peak2-time_peak1;

    %delta value
    delta = log(peak1/peak2);

    %zeta (damping ratio)
    zeta = delta/(sqrt((2*pi)^2+delta^2));
    
    %omega_d (dampened natural frequency)
    omega_d = (2*pi)/time_delta;

    %omega_n (natural frequency)
    omega_n = omega_d/(sqrt(1-zeta^2));

    %amplitude
    A = peak1;

    %phi (phase): cosine term should be 1 at first peak
    %cos(omega_d * t - phi) = 1  =>  omega_d * t - phi = 0
    %therefore phi = omega_d * time_peak1
    phi = omega_d * time_peak1;

    %calculate the damped oscillation
    fit_accel = @(t) A * exp(-zeta * omega_n * t) .* cos(omega_d * t - phi);

    figure();
    hold on;

    plot(time, acceleration, 'b.', 'DisplayName', 'Experimental Data');

    plot(time, fit_accel(time), 'r-', 'LineWidth', 2, 'DisplayName', 'Fitted Analytic Solution');
    
    title('Experimental Data vs. Analytic Solution');
    xlabel('Time (s)');
    ylabel('Acceleration (m/s^2)');
    legend('show');
    grid on;
    
    fprintf('System Parameters');
    fprintf('Damping Ratio (zeta): %.4f\n', zeta);
    fprintf('Damped Natural Frequency (omega_d): %.4f rad/s\n', omega_d);
    fprintf('Natural Frequency (omega_n): %.4f rad/s\n', omega_n);
end