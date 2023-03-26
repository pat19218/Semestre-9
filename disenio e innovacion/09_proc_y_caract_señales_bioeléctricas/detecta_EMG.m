%% detecta_EMG
%  Author: Luis Alberto Rivera

%  Event detection for one particular signal, the absolute value of the input signal and a
%  fixed time window.
%  Inputs:
%     y - vector with the sampled data from which the activity signal is to be extracted
%    Fs - sampling frequency
%   win - time window size in mili seconds
%    Tn - the initial period (in ms) in which EMG activity is NOT present, only noise
%    ga - should be > 1. Constant used to define the threshold: th = ga*M, M = max(eta(t))
%   opt - option for plotting: 0 - no plot
%                           > 0 - plots original and extracted signal in figure # opt.
%  Output:
%    es - extracted or detected signal, which is only win ms worth of data.
function es = detecta_EMG(y, Fs, win, Tn, ga, opt)

% we want a column vector, so transpose y if it is a row vector
if size(y,1) == 1
    y = y';
end

y = y - mean(y);            % in case y is not centered

L = length(y);
w = ceil(0.025*L);          % window width: 2.5% of the number of data points per signal
T_tot = 1000*L/Fs;          % original signal duration, in mili seconds
wp = ceil(L*win/T_tot);     % translation of time window in ms to number of points

eta = abs(y);

m = ceil(L*Tn/T_tot);       % Translate Tn to sample points: noise is considered to be in points 1:m
M = max(eta(1:m));
th = ga*M;                  % threshold value
det_vector = eta > th;      % sets 1 if eta is greater than the threshold, 0 otherwise.
min_den = 0.02*sum(det_vector); % minimal density, a percentage of the total number of ones.

temporal = zeros(1,L+2*w);
temporal((1+w):(L+w)) = det_vector;
act_intervals = zeros(1,L);

for k = (1+w):(L+w)
    leftden = sum(temporal((k-w):(k-1)));
    rightden = sum(temporal((k+1):(k+w)));
    if ((leftden > 0) && (rightden > 0))   % at least one before and one after
        if ((leftden + rightden) >= min_den)
            act_intervals(k-w) = 1;
        end    
    end    
end    

% The two following  for loops are to eliminate small gaps in the active intervals
u = ceil(0.015*L);
for k = (1+u):(L-u)
    if ((act_intervals(k) == 0) && (sum(act_intervals((k-u):(k-1))) > 0) && (sum(act_intervals((k+1):(k+u))) > 0))
        act_intervals(k) = 1;
    end   
end    

for k = (1+u):(L-u)
    if ((act_intervals(k) == 0) && (sum(act_intervals((k-u):(k-1))) > 0) && (sum(act_intervals((k+1):(k+u))) > 0))
        act_intervals(k) = 1;
    end   
end

% The following is to detect the main part(s) of the signal
k = 1;
first_one = [0,0];      % 2, in case there are two main parts in the signal
last_one = [0,0];
j = 1;                  % j = 1 or 2. It is for the first/last_one vectors
while (k <= L)
    if (first_one(j) == 0)
        if (act_intervals(k) == 1)
            first_one(j) = k;
        end
    else
        if (act_intervals(k) == 0)
            last_one(j) = k - 1;
            if ((last_one(j) - first_one(j)) >= wp/5)
                if (j == 1)
                    j = 2; %k = L;
                else
                    k = L;
                end    
            else
                first_one(j) = 0;
                last_one(j) = 0;
            end    
        end
    end
    k = k+1;
end    

% The following is to determine where the (extraction) signal starts and where it ends.
% It will consist in exactly wp points, which correspond to the desired win time window.
if ((first_one(2) - last_one(1)) > wp/5)
    first_one(2) = 0;
    last_one(2) = 0;
end    

if (first_one(1) ~= 0)             % would be zero if no significative signal was detected
    first_ = first_one(1);
    if (first_one(2) == 0)          % if there is NOT a second main part
        last_ = last_one(1);
    else
        last_ = last_one(2);        % if there IS a second main part
    end

    if (first_ > (L - wp))
        first_ = L - wp;
    end
    
    if ((last_ == 0) || (last_ < (first_ + wp)))
        k = first_ + wp;
        while (k > first_)
            if (act_intervals(k) == 1)
                last_ = k;
                k = first_;
            end
            k = k - 1;
        end    
    end
else
    first_ = 0;
    last_ = 0;
end

center = ceil((first_ + last_)/2);

if (center == 0)            % in case the detection failed (or too few points were detected)
    center = find(eta >= max(eta));   % sets the center where eta is maximum
    center = center(1);     % in case the absolute maximum is present in more than one location
end 


% The following establishes the valid interval (of length win) for the signal
if ((center - ceil(wp/2)) < 1)
    a = 1;
    b = a + wp -1;
else
    if ((center + ceil(wp/2)) > L)
        b = L;
        a = b - wp + 1;
    else     
        a = center - ceil(wp/2);
        b = a + wp - 1;
    end
end    
    
final_act_intervals = [zeros(a-1,1);ones(wp,1);zeros(L-b,1)];
det_signal = y .* final_act_intervals;

t = (0:(L-1))/(Fs);

% Plotting: only if opt > 0
if (opt > 0)
    figure(opt)
    clf
    subplot(3,1,3);
    plot(t(a:b),det_signal(a:b),'r');
    axis auto;
    ylabel('extracted signal');
    xlabel('time (sec)');
    subplot(3,1,2);
    plot(t,det_signal);
    axis auto;
    ylabel('detected signal');
    subplot(3,1,1);
    plot(t,y);
    hold on;
    plot(t,max(y)*final_act_intervals,'r');
    ylabel('recorded signal');
    axis auto;
    title('Detection Scheme Using abs and fixed window approach');
    hold off;    
end    

es = det_signal(a:b);   % extracted signal: only wp points, i.e., win ms worth of data.

end
