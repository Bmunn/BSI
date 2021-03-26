%% Particpation calculation

%Download code below from
%https://github.com/macshine/integration

%obtain Participation (PC) 

% After calculation of mean Participation Loop through each voxel and
% caclulating max to recreate travelling wave
allLags =nan(1,400);
for vv = 1:400
[xcf,lags] = crosscorr(BT,cortSig(:,vv));

%plot fig 1C
plot(xcf,lags) 
[M,I] = max(xcf);
allLags(vv) = lags(I);
end

%Plotting the allLags on the cortical flatmap will recreate Fig. 1b

%% MSD calculation and Energy plots

%number of tr into future calc msd
ndt = 50;

ds = 0:1:50; % the msd range calculated across


% MSD calculation
MSD = mean( (cortSig(1+dt:end,:) - cortSig(1:end-dt,:)).^2,2) ;


nrgLC = nan(ndt-1,numel(ds));
nrgBNM = nan(ndt-1,numel(ds));
nrgLCBNM = nan(ndt-1,numel(ds));
nrgBase = nan(ndt-1,numel(ds));

for dt = 2:ndt

%%
% MSD calculation
MSD = mean( (cortSig(1+dt:end,:) - cortSig(1:end-dt,:)).^2,2) ;


%Get the locations of when phasic bursts start 
[LClocs,BNMlocs,LCBNMlocs,Baselocs] = LcBnmPkTime(lc_ts,bnm_ts,dt);


msdLC = MSD(LClocs);
msdBNM = MSD(BNMlocs);
msdLCBNM = MSD(LCBNMlocs);
msdBase = MSD(Baselocs);

%% Calculate probability distribution  and energy for each dt and each neuromod

dat = msdLC;
pd = fitdist(dat,'Kernel','BandWidth',bdw);
yLC = pdf(pd,ds);
nrgLCdt = -1.*log(yLC);


dat = msdBNM;
pd = fitdist(dat,'Kernel','BandWidth',bdw);
yBNM = pdf(pd,ds);
nrgBNMdt = -1.*log(yBNM);


dat = msdLCBNM;
pd = fitdist(dat,'Kernel','BandWidth',bdw);
yLCBNM = pdf(pd,ds);
nrgLCBNMdt = -1.*log(yLCBNM);


dat = msdBase;
pd = fitdist(dat,'Kernel','BandWidth',bdw);
yBase = pdf(pd,ds);
nrgBasedt = -1.*log(yBase);


% Pool results across time
nrgLC(dt-1,:) = nrgLCdt;
nrgBNM(dt-1,:) = nrgBNMdt;
nrgLCBNM(dt-1,:) = nrgLCBNMdt;
nrgBase(dt-1,:) = nrgBasedt;

end

%  Plot estimated MSD energy landscape 
% Fig. 2C

x = 1:ndt-1;
y = ds;
[X,Y] = meshgrid(x,y);

xmax = 50;

subplot(2,2,1)
mesh(X,Y,nrgBase','EdgeColor', [105,105,105]./255)
xlabel('TR')
ylabel('MSD')
zlabel('MSD  energy')
xlim([1 xmax])
zlim([2 78])
ylim([1 50])
view(-15,30)   % XZ
title('Baseline')

subplot(2,2,2)
mesh(X,Y,nrgLC','EdgeColor', [236 102 102]./255)
xlim([1 xmax])
zlim([2 78])
ylim([1 50])
view(-15,30)   % XZ
xlabel('TR')
ylabel('MSD')
zlabel('MSD  energy')
title('LC')


subplot(2,2,3)
mesh(X,Y,nrgBNM','EdgeColor', [60 184 79]./255)
xlim([1 xmax])
zlim([2 78])
ylim([1 50])
view(-15,30)   % XZ
xlabel('TR')
ylabel('MSD')
zlabel('MSD  energy')
title('BNM')