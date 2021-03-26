function [LClocs,BNMlocs,LCBNMlocs,Baselocs] = LcBnmPkTime(lc_ts,bnm_ts,dt)


%Takes in the LC and BNM activity, finds the peaks times that satisfy the
%phasic increase followed by significant peak 
%ouputs the lc peaks, bnm peaks, LC+BNM and times outside of these windows

%% For example process we have concatenated all recordings
%Entries near end/beginning of subject within a dt (but factoring in acc
%peak occuring 10 tr post must be atleast 10 TR)

edgvals = repmat(1050-max([dt 10]):1050+max([dt 10]),61,1) + repmat(-1050:1050:63000-1050,2*max([dt 10])+1,1)';
edgvals = edgvals(:);


%% First LC-BNM peaks 


sig = lc_ts-bnm_ts; %grab signal


%Calc acc find phasic peaks with 
sigAcc = gradient(gradient(sig));
[~,locs] =  findpeaks(sigAcc,'MinPeakDistance',10); %find peaks of acc

%Remove locs near boundaries
locs = locs(~ismember(locs,edgvals));

%Now only take the locations where the phasic burst (acc) maximises high later on 
locs = locs(sig(locs+10)>2*std(sig));

LClocs = locs;

%% BNM-LC peaks

sig = bnm_ts-lc_ts; %grab signal


%Calc acc
sigAcc = gradient(gradient(sig));
[~,locs] =  findpeaks(sigAcc,'MinPeakDistance',10); %find peaks of acc

%Remove locs near boundaries
locs = locs(~ismember(locs,edgvals));

%Now only take the locations where the phasic burst (acc) maximises high later on 
locs = locs(sig(locs+10)>2*std(sig));

BNMlocs = locs;

%% LC+BNM peaks

sig = bnm_ts+lc_ts; %grab signal


%Calc acc
sigAcc = gradient(gradient(sig));
[~,locs] =  findpeaks(sigAcc,'MinPeakDistance',10); %find peaks of acc

%Remove locs near boundaries
locs = locs(~ismember(locs,edgvals));

%Now only take the locations where the phasic burst (acc) maximises high later on 
locs = locs(sig(locs+10)>2*std(sig));

LCBNMlocs = locs;

%% Baseline times

%compile locations of phasic bursts
allLocs=[LClocs; BNMlocs; LCBNMlocs];

%trick to avoid -30 TR before a acc peak
nearLocs = repmat(-30:0,numel(allLocs),1)+allLocs;

%then get the indices that arent edge values or near a loc
allindx = 1:numel(sig);
Baselocs = allindx(~ismember(allindx,[nearLocs(:); edgvals(:)]));






end


