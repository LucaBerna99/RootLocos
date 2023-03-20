function K_aero_MAP(fig)

%% README
% K_aero_MAP computes the third order regression of the curve (MAP)
% relating Aerodynamic Coefficient (K_aero) and Motor Supply Voltage (Vdc)
% from given data.
% 
% The function takes as INPUT a boolean variable <fig> which is used by the 
% user to state whether or not the graphs have to be plotted. 
%
% Defining the MAP as:  K_aero(Vdc) = p4*Vdc^3 + p3*Vdc^2 + p2*Vdc + p1
%
% ( Note that the MAPS are different for Positive and Negative Voltages!  )
%
% The function gives as OUTPUT two vectors <w_pos> and <w_neg> of weights
% containing the coefficients of the identified curves in the two cases.

%% GLOBAL VARIABLES DEFINITION

global w_pos
global w_pos_0
global w_pos_1
global w_neg
global w_neg_0
global w_neg_1
global w_static

%% LOCAL VARIABLES DEFINITION

voltages_pos = [0, 4, 6, 8, 10, 12, 14, 16, 18]';
voltages_neg = -flip(voltages_pos);

%% ---------------------- MOTOR 0 POSITIVE MAP ----------------------------

load("K_aero_0P.mat");
K0P = abs(K_aero_0_positive(2,:));
K0P = cat(2, 0, K0P);

% CURVE FITTING
positive_0 = fit(voltages_pos, K0P','poly3');

% OUTPUT IS SAVED IN THE GLOBAL VARIABLE
w_pos_0 = [positive_0.p4, positive_0.p3, positive_0.p2, positive_0.p1];

%% ---------------------- MOTOR 1 POSITIVE MAP ----------------------------

load("K_aero_1P.mat");
K1P = abs(K_aero_1_positive(2, :));
K1P = cat(2, 0, K1P);

% CURVE FITTING
positive_1 = fit(voltages_pos, K1P','poly3');

% OUTPUT IS SAVED IN THE GLOBAL VARIABLE
w_pos_1 = [positive_1.p4, positive_1.p3, positive_1.p2, positive_1.p1];

%% ------------------------- POSITIVE MAP ---------------------------------
% LOADING K_AERO DATA WITH POSITIVE VOLTAGE SUPPLIES
load("K_aero_0P.mat");
load("K_aero_1P.mat");

% VARIABLES DEFINITION
K_average_pos = 0.5*(K0P + K1P);
KP = K_average_pos';

% CURVE FITTING
positive = fit(voltages_pos, KP,'poly3');

% OUTPUT IS SAVED IN THE GLOBAL VARIABLE
w_pos = [positive.p4, positive.p3, positive.p2, positive.p1];

%% ------------------- POSITIVE GRAPH PLOTTING ----------------------------
if fig == 1
    set(figure(), "WindowStyle","docked")
    plot (positive, voltages_pos, KP) 
    title("K_{AERO} POSITIVE FITTING")
    legend("K_{AERO} POSITIVE DATA", "K_{AERO} POSITIVE FITTED CURVE")

    
    set(figure(), "WindowStyle","docked")
    plot (positive_0, voltages_pos, K0P)
    title("K_{AERO} M0 POSITIVE FITTING")
    legend("K_{AERO} POSITIVE DATA", "K_{AERO} POSITIVE FITTED CURVE")
    
    set(figure(), "WindowStyle","docked")
    plot (positive_1, voltages_pos, K1P)
    title("K_{AERO} M1 POSITIVE FITTING")
    legend("K_{AERO} POSITIVE DATA", "K_{AERO} POSITIVE FITTED CURVE")
end

%% --------------------- MOTOR O NEGATIVE MAP -----------------------------
load("K_aero_0N.mat");
K0N = -abs(K_aero_0_negative(2,:));
K0N = cat(2, K0N, 0);

% CURVE FITTING
negative_0 = fit(voltages_neg, K0N','poly3');

% OUTPUT IS SAVED IN THE GLOBAL VARIABLE
w_neg_0 = [negative_0.p4, negative_0.p3, negative_0.p2, negative_0.p1];

%% ---------------------- MOTOR 1 NEGATIVE MAP ----------------------------

load("K_aero_1N.mat");
K1N = -abs(K_aero_1_negative(2, :));
K1N = cat(2, K1N, 0);

% CURVE FITTING
negative_1 = fit(voltages_neg, K1N','poly3');

% OUTPUT IS SAVED IN THE GLOBAL VARIABLE
w_neg_1 = [negative_1.p4, negative_1.p3, negative_1.p2, negative_1.p1];

%% ------------------------- NEGATIVE MAP ---------------------------------

% LOADING K_AERO DATA WITH NEGATIVE VOLTAGE SUPPLIES
load("K_aero_0N.mat");
load("K_aero_1N.mat");

% VARIABLES DEFINITION
K_average_neg = 0.5*(K0N + K1N);
KN = K_average_neg';

% CURVE FITTING
negative = fit(voltages_neg, KN,'poly3');

% OUTPUT IS SAVED IN THE GLOBAL VARIABLE
w_neg = [negative.p4, negative.p3, negative.p2, negative.p1];

%% ---------------------- NEGATIVE GRAPH PLOTTING -------------------------
if fig == 1
    set(figure(), "WindowStyle","docked")
    plot (negative, voltages_neg, KN) 
    title("K_{AERO} NEGATIVE FITTING")
    legend("K_{AERO} NEGATIVE DATA", "K_{AERO} NEGATIVE FITTED CURVE")

    
    set(figure(), "WindowStyle","docked")
    plot (negative_0, voltages_neg, K0N)
    title("K_{AERO} M0 NEGATIVE FITTING")
    legend("K_{AERO} NEGATIVE DATA", "K_{AERO} NEGATIVE FITTED CURVE")
    
    set(figure(), "WindowStyle","docked")
    plot (negative_1, voltages_neg, K1N)
    title("K_{AERO} M1 NEGATIVE FITTING")
    legend("K_{AERO} NEGATIVE DATA", "K_{AERO} NEGATIVE FITTED CURVE")
end

%% -------------------------- K_AERO STATIC -------------------------------

KP_STATIC = 0.5*(K1P + K0P);
KN_STATIC = 0.5*(K1N + K0N);
K_STATIC = cat(2, KN_STATIC, KP_STATIC);

all_voltages = cat(1, voltages_neg, voltages_pos);
% CURVE FITTING
static = fit(all_voltages, K_STATIC','poly1');

% OUTPUT IS SAVED IN THE GLOBAL VARIABLE
w_static = [static.p2, static.p1];

%% ----------------------- STATIC GRAPH PLOTTING --------------------------

if fig == 1
    set(figure(), "WindowStyle","docked")
    plot (static, all_voltages, K_STATIC) 
    title("K_{AERO} STATIC FITTING")
    legend("K_{AERO} STATIC DATA", "K_{AERO} STATIC FITTED CURVE")    
end

end