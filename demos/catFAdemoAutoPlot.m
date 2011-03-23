
function plotFn(data, mu, str, nClass)

[D,N] = size(data.continuous);
for i = [1 3] % we use discrete features 1 and 3
  if i == 1
    colors = [0 0 0; 1/4 0 0; 2/4 0 0; 3/4 0 0; 1 0 0];
    markers = {'x','o','*','d','s'};
  elseif i == 3
    colors = [1 0 1; 0 1 0; 0 0 1];
    markers = {'o','d','s'};
  end
  figure;
  hold on
  for j = 1:nClass(i)
    idx = find(data.discrete(i,:) == j);
    h(j) = plot(mu(1,idx), mu(2,idx),'o','color', colors(j,:),'marker',markers{j});
  end
  if i == 1
    legend('1','2','3','4','5','location','northwest');
    ht = title(sprintf('method %s, color = #Cylinders', str));
  elseif i == 3
    legend('US','Europe','Japan','location','northwest');
    ht = title(sprintf('method %s, color = Country', str));
  end
  hx = xlabel('Factor 1');
  hy = ylabel('Factor 2');
  xlim([-3,3]);
  ylim([-3,3]);
  
  set(gca,'fontname','Helvetica');
  set([hx,hy],'fontname','avantgarde','fontsize',13,'color',[.3 .3 .3]);
  set(ht,'fontname','avantgarde','fontsize',13,'fontweight','bold');
  set(gca,'box','off','tickdir','out','ytick',[-3 0 3],'xtick',[-3 0 3], ...
    'ticklength',[.02 .02],'xcolor',[.3 .3 .3],'ycolor',[.3 .3 .3],'linewidth',1);
end

end

function [data, nClass] = getAutoData()

%Y = importdata('/global/scratch/emtiyaz/datasets/imputation/auto-mpg.data');
%Y = importdata([dirName 'imputation/auto-mpg.data']);
tmp = loadData('autompg');
Y = tmp.X; % 392 x 8
idx = find(~sum(isnan(Y),2));
X = Y(idx,:);
names = {'mpg','cylinders', 'displacement','horsepower','weight','acceleration','modelYear','origin'};

% recode cyclinder
val= [3 4 5 6 8];
X(:,2) = arrayfun(@(v)find(v==val), X(:,2));
% recode years
X(:,7) = X(:,7) - 69;
% standardize continuous
Y = X(:,[1 3 4 5 6]);
Y = (Y-repmat(mean(Y),size(Y,1),1))./repmat(std(Y),size(Y,1),1);
data.continuous = Y';
data.discrete = X(:,[2 7 8])';
if 0 % strcmp(name, 'autoSmall')
  data.continuous = data.continuous(:,1:200);
  data.discrete = data.discrete(:,1:200);
end
nClass = max(data.discrete,[],2);
%names = {'mpg','displacement','horsepower','weight','acceleration','cylinders','modelYear','origin'};
data.names = names([1 3 4 5 6 2 7 8]);

%{
% keep only the dimensions which have more than 1 class
idx = [];
for d = 1:size(data.discrete,1)
  if ~(length(unique(data.discrete(d,:)))==1)
    idx = [idx; d];
  end
end
idx
data.discrete = data.discrete(idx,:);
nClass = max(data.discrete,[],2);
%if isfield(data, 'names')
%  data.names = data.names(idx);
%end
  %}

end

