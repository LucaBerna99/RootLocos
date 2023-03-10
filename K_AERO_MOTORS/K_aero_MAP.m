function K_aero_MAP(fig)

    % K_aero_MAP computes the second order regression of the curve (MAP)
    % relating Aerodynamic Coefficient (K_aero) and Motor Supply Voltage (Vdc)
    % from given data.
    % 
    % The function takes as INPUT a boolean variable <fig> which is used by the 
    % user to state whether or not the graphs have to be plotted. 
    %
    % Defining the MAP as:  K_aero(Vdc) = w2*Vdc^2 + w1*Vdc + w0
    %
    % ( Note that the MAPS are different for Positive and Negative Voltages!  )
    %
    % The function gives as OUTPUT two vectors <w_pos> and <w_neg> of weights
    % containing the coefficients of the identified curves in the two cases.
    
    %% GLOBAL VARIABLES DEFINITION
    
    global w_pos w_neg
    
    %% ------------------------- POSITIVE MAP ---------------------------------
    % LOADING K_AERO DATA WITH POSITIVE VOLTAGE SUPPLIES
    load("K_aero_0P.mat");
    load("K_aero_1P.mat");
    
    % VARIABLES DEFINITION
    voltages = [4, 6, 8, 10, 12, 14, 16, 18]';
    K_average_pos = 0.5*(abs(K_aero_0_positive(2,:)) + abs(K_aero_1_positive(2, :)));
    KP = K_average_pos';
    
    % CURVE FITTING
    positive = fit(voltages, KP,'poly2');
    
    % OUTPUT IS SAVED IN THE GLOBAL VARIABLE
    w_pos = [positive.p3, positive.p2, positive.p1];
    
    % GRAPH PLOTTING
    if fig == 1
        set(figure(), "WindowStyle","docked")
        plot (positive, voltages, KP)
        title("K_{AERO} POSITIVE FITTING")
        legend("K_{AERO} POSITIVE DATA", "K_{AERO} POSITIVE FITTED CURVE")
    end
    
    %% ------------------------- NEGATIVE MAP ---------------------------------
    
    % LOADING K_AERO DATA WITH NEGATIVE VOLTAGE SUPPLIES
    load("K_aero_0N.mat");
    load("K_aero_1N.mat");
    
    % VARIABLES DEFINITION
    K_average_neg = 0.5*(abs(K_aero_0_negative(2,:)) + abs(K_aero_1_negative(2, :)));
    KN = K_average_neg';
    
    % CURVE FITTING
    negative = fit(voltages, KN,'poly2');
    
    % OUTPUT IS SAVED IN THE GLOBAL VARIABLE
    w_neg = [negative.p3, negative.p2, negative.p1];
    
    % GRAPH PLOTTING
    if fig == 1
        set(figure(), "WindowStyle","docked")
        plot (negative, voltages, KN)
        title("K_{AERO} NEGATIVE FITTING")
        legend("K_{AERO} NEGATIVE DATA", "K_{AERO} NEGATIVE FITTED CURVE")
    end

end

