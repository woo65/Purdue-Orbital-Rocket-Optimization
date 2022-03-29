function [Altitude, Drag, Velocity] = altitude_analysis(Thrust, M, dt, stage_width, starting_altitude)

    %Constants
    Cd = 0.6;
    g = 9.81;
    dtFactor = 1; %a remnant of a bygone era
    %Starting Values
    Velocity(1) = 0;
    Altitude(1) = starting_altitude;
    % Final Altitude
    i = 2;
    while Velocity(i-1) >= 0
        [rho,a,Temp,P,nu,z,sigma] = atmos(Altitude(i-1));
        if i <= length(Thrust)*dtFactor
            Drag(i) = 0.5 * Cd * rho * Velocity(i-1)^2 * (stage_width / 2)^2 * pi;
            fNet(i) = Thrust(round(i/dtFactor)) - Drag(i) - M(round(i/dtFactor)) * g;
            accel(i) = fNet(i) / M(round(i/dtFactor));
            Velocity(i) = accel(i) * dt + Velocity(i-1);
            Altitude(i) = Velocity(i) * dt + Altitude(i-1);
        else
            Drag(i) = 0.5 * Cd * rho * Velocity(i-1)^2 * (stage_width / 2)^2 * pi;
            fNet(i) = -Drag(i) - M(end) * g;
            accel(i) = fNet(i) / M(end);
            Velocity(i) = accel(i) * dt + Velocity(i-1);
            Altitude(i) = Velocity(i) * dt + Altitude(i-1);
        end
        i = i + 1;
    end
        
    T = linspace(0, dt*length(Altitude), length(Altitude));
    figure(2)
    plot(flip(T),flip(Altitude(1:length(T))));
    title('Altitude (m)');
    grid on;
    
    figure(3)
    plot(flip(T),flip(Velocity(1:length(T))));
    title('velocity (m/s)');
    grid on;
    
    figure(4)
    plot(flip(T),flip(Drag(1:length(T))));
    title('drag (N)');
    grid on;
    
    disp(Altitude(end));

end