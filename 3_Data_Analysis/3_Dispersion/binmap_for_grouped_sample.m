nbin = size(sample_strfun_shorten, 1);
figure;
map = [];
y_mean = [];
for i = 1 : nbin
%     x_l = xmin + (i - 1) * dx;
%     x_u = xmin + i * dx;
%     x_l = dx(i);
%     x_u = dx(i + 1);
     xx = (redge(i) + redge(i+1)) / 2 /0.05;
%     yy = y(x > x_l & x < x_u);
%     [C,~,ic] = unique(yy);
%     a_counts = accumarray(ic,1); 
yy = nonzeros(sample_strfun_shorten(i,:).^2);
if isempty(yy)
    map = [map; [xx, 0, 0]];
        continue;
end
    h = histogram(yy);
    cn = h.Values;
    cr = h.BinEdges(2:end);
    if length(yy) > 1
        y_mean(i,:) =  MeanWithConfidenceInterval(yy);
    else
        y_mean(i,:) = [mean(yy), 0 , 0];
    end
    
%     map = [map; [ones(length(C),1) * xx, C, a_counts / sum(a_counts)]];
    map = [map; [ones(length(cr),1) * xx, cr', cn' / sum(cn)]];
end

createfigure(map(:,1), map(:,2), [] , map(:,3));
hold on
errorbar(redge(2:end)/0.05, y_mean(:,1), y_mean(:,2), y_mean(:,3))


function createfigure(X1, Y1, S1, C1)
%CREATEFIGURE(X1, Y1, S1, C1)
%  X1:  scatter x
%  Y1:  scatter y
%  S1:  scatter s
%  C1:  scatter c

%  Auto-generated by MATLAB on 10-Dec-2019 15:53:40

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create scatter
scatter(X1,Y1,S1,C1,'MarkerFaceColor','flat','MarkerEdgeColor','none');

box(axes1,'on');
% Set the remaining axes properties
% set(axes1,'ColorScale','log','FontSize',18,'LineWidth',2,'XMinorTick','on',...
%    'YMinorTick','on','YScale','log');
set(axes1,'FontSize',18,'LineWidth',2,'XMinorTick','on',...
    'YMinorTick','on');
% Create colorbar
colorbar(axes1,'LineWidth',2);
end