%% define folder path
clear all
scenario_fdpth = 'D:\004 FLOW VELOCIMETRY DATA\c23wv\99';

%% find potential images
imgList = dir(fullfile(scenario_fdpth,'*.tif'));
NoI = numel(imgList);
imgIdxList = zeros(NoI,1);
for i_img = 1:NoI
    imgName = imgList(i_img).name;
    nameTemp= strsplit(imgName,'_');
    imgIdxStr = nameTemp{2}; %e.g. 0032.tif or 000011.tif
    imgIdx    = str2double(imgIdxStr(1:end-4));
    imgIdxList(i_img) = imgIdx;
end 
clearvars nameTemp imgIdxStr i_img imgIdx

%% find lib* file to extend 
libFile = dir(fullfile(scenario_fdpth,'lib*.mat'));
if isempty(libFile)
    error('Cannot find exsting lib* file');
elseif numel(libFile)>1
    error('Find multiple lib* files')
else 
    libFileName = libFile.name;
end

%%
load(fullfile(scenario_fdpth,libFileName))

nframes_old = nframes;

prompt = {sprintf('Start from : (>%d)',min(imgIdxList)),...
          sprintf('End with : (<%d)',max(imgIdxList))};
dlgtitle = sprintf('%d to %d clicked',...
           list(1),list(end));
dims = [1 60];
definput = {'1',num2str(NoI)};
opts.Resize = 'on';
answer = inputdlg(prompt,dlgtitle,dims,definput,opts);


beginimg = str2double(answer{1});
endimg   = str2double(answer{2});
list     = beginimg:endimg;
nframes  = numel(list);

%% extend and pad new ones with the last element
for i = nframes_old+1:nframes 
    % shape: [nframes,2]
    phase(i,:)    = phase(nframes_old,:); %#ok<*SAGROW>
    phishape(i,:) = phishape(nframes_old,:);
    % shape: [nframes,2,26]
    Bshape(i,:,:) = Bshape(nframes_old,:,:);
    velx0(i,:,:)  = velx0(nframes_old,:,:);
    vely0(i,:,:)  = vely0(nframes_old,:,:);
    xflag(i,:,:)  = xflag(nframes_old,:,:);
    yflag(i,:,:)  = yflag(nframes_old,:,:);
    % shape: [nframes,2,27]
    kappasave(i,:,:) = kappasave(nframes_old,:,:);
end


%% save new lib file
nameTemp = strsplit(libFileName,'_');
newLibFileName = [nameTemp{1},'_',answer{1},'_',answer{2},'.mat'];
clearvars imgList NoI imgIdxList libFile libFileName...
    nameTemp i prompt dlgtitle dims definput opts answer
save(fullfile(scenario_fdpth,newLibFileName))

%% remind user
disp('Run AA_Correct_Frames.m to manually redefine the extended')