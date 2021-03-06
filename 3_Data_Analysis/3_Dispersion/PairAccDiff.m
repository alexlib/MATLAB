function [vel_diff, veldiff_matrix, Acgs_matrix] = PairAccDiff(pairs, data_map)

trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);
num_pair = size(pairs, 1);

len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
veldiff_matrix = zeros(num_pair, len);
Acgs_matrix = zeros(num_pair, len);
r_matrix = zeros(num_pair, len);
for i = 1 : num_pair
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    direction = track1(1 : len, 1:3) - track2(1 : len, 1:3);
    r_matrix(i, 1:len) = vecnorm(direction, 2, 2);
%     direction = direction ./ vecnorm(direction, 2, 2);
    veldiff_vec = (track1(1 : len, 9:11) - track2(1 : len, 9:11)) / 1e3;
    veldiff_sca = vecnorm(veldiff_vec, 2, 2).^2;
    veldiff_matrix(i, 1 : len ) = veldiff_sca;
    
    %% coarse-grained squared acceleration
    t_kol = 0.0035;
    fitwidth = t_kol * 4000 * 2;
    filterwidth = fitwidth;
%     fitl = 1:fitwidth;
%     Av = 1./(2.*sum((fitl.*fitl).*exp(-(fitl.*fitl)./filterwidth^2)));
    Av = 1 / ((2 * pi)^.5 * filterwidth);
    vkernel = -fitwidth:fitwidth;
%     vkernel = Av.*vkernel.*exp(-vkernel.^2./filterwidth^2);
    vkernel = Av*exp(-vkernel.^2./filterwidth^2);

%         w = filterwidth;
%         rwsq = 1./(w^2);
%         coef = 2.*rwsq./(sqrt(pi).*w);
%         
%         fitl = -fitwidth:fitwidth;
%         sumtsq = sum(fitl.*fitl);
%         sumk = sum(coef.*(2.*fitl.*fitl.*rwsq-1)./exp(fitl.*fitl.*rwsq));
%         sumktsq = sum(fitl.*fitl.*coef.*(2.*fitl.*fitl.*rwsq-1)./exp(fitl.*fitl.*rwsq));
% 
%         A = 2./(sumktsq - sumk.*sumtsq./(2*fitwidth));
%         B = -A.*sumk./(2*fitwidth);
%         
%         
%         akernel = -fitwidth:fitwidth;
%         akernel = A.*coef.*(2.*akernel.^2.*rwsq-1)./exp(akernel.^2.*rwsq)+B;
    
    a_cgs = conv(veldiff_sca,vkernel,'valid');
    Acgs_matrix(i, 1 : length(a_cgs) ) = a_cgs;
    
%     veldiff_lgtn = dot(veldiff_vec, direction, 2) / 1e3;
%     veldiff_sca = veldiff_sca - veldiff_sca(1);
%     veldiff_matrix(i, 1 : len) = veldiff_lgtn .^ 2;

%     veldiff_vec = veldiff_vec - veldiff_vec(1, :);
%     veldiff_matrix(i, 1 : len - 1) = vecnorm(veldiff_vec(2:end,:), 2, 2) .^2;
%      veldiff_matrix(i, 1 : len ) = veldiff_vec(:, 1:3) * veldiff_vec(1, 1:3)';
end
len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
vel_diff = zeros(len, 1); 
r = zeros(len, 1); 
for i = 1 : len
    disp = nonzeros(Acgs_matrix(:, i));
    disp_r = nonzeros(r_matrix(:, i));
    if ~isempty(disp)
        vel_diff(i) = mean(disp);
        r(i) = mean(disp_r);
%         [cn, cr] = hist(disp / mean(disp) , 10.^[-3:0.1:3]);
% 
%         vel_diff(i) = MeanOfcertainProbability(cn, cr, 0.6) * mean(disp);
    end
end
vel_diff = nonzeros(vel_diff);
r = nonzeros(r);
end

function cr_m = MeanOfcertainProbability(cn, cr, probability)

cn_max = max(cn);

prob = 0;
cn_m = cn_max / 2;
cn_low = 0;
cn_up = cn_max;

while(abs(prob - probability) > 0.01)
    if abs(cn_up - cn_low) < 1e-3
        break;
    end
    cn_m = (cn_low + cn_up) / 2;
    cn_series = cn(cn > cn_m);
    prob = sum(cn_series) / sum(cn);
    if prob < probability
        cn_up = cn_m;
    else
        cn_low = cn_m;        
    end
    
end
cr_series = cr(cn > cn_m);
cr_m = dot(cr_series , cn_series) / sum(cn_series);
end
