%% Doc
% this function helps user see if the recognized slips are real slips
% Ph_interflag: phase difference between two flagella
% img_fdpth:    the folder path that stores the images
% fps_img:      frame rate of the image sequence
% Fs_PhSig:     sampling frequency of Ph_interflag. The routine
%               interpolates with 1kHz
%%
function [N_realSlip,...
          N_falseSlip,...
          idx_realSlip,...
          idx_falseSlip]    =checkPhaseSlipByUser(Ph_interflag,img_fdpth,...
                                                  fps_img,Fs_PhSig,varargin)
    NoArgInExtra  =  nargin  - 4;
    if NoArgInExtra > 0
        temp = strcmp(varargin,'Crop'); 
        if any(temp); cropImg=1; cropRect = varargin{find(temp)+1}; end
    end         
    
    
    N_falseSlip = 0;
    N_realSlip =  0;
    idx_falseSlip = [];
    idx_realSlip  = [];
    singleSlipDuration = 0.06*Fs_PhSig;  % 0.06 s, 3 cycles
    
    %% find the longest synchronous range to sample noise level
    % complicated algorithm failed
    stdSig     = 5e-4;
    
    %% determine center of slips by comparing with noise level     
    searchPeak = smooth(diff(Ph_interflag),ceil(singleSlipDuration));
    searchPeak = searchPeak - mean(searchPeak);
    [~,SlipCents]   = findpeaks(abs(searchPeak),...
                    'MinPeakProminence',6*stdSig);
                
    %% check each slip with corresponding images           
    if numel(SlipCents) >= 1
        figure('Units','pixels','Position',[60 150 700 550])
        setappdata(gcf,'N_realSlip',N_realSlip)
        setappdata(gcf,'idx_realSlip',idx_realSlip)
        setappdata(gcf,'N_falseSlip',N_falseSlip)
        setappdata(gcf,'idx_falseSlip',idx_falseSlip)
        
        for i_slip = 1:numel(SlipCents)
            imgIdx_slipCent = floor(SlipCents(i_slip)/...
                                Fs_PhSig*fps_img);
            sampleImgIdx = [-2:2:28]; %#ok<NBRAK>
            NoSampleImg  = numel(sampleImgIdx);
            NoRowPanel   = ceil(sqrt(NoSampleImg));

            file_format_str = '%04d';
            testImgName  = ['1_',num2str(1,file_format_str),'.tif'];
            if ~exist(fullfile(img_fdpth,testImgName),'file')
                file_format_str = '%06d';
                testImgName  = ['1_',num2str(1,file_format_str),'.tif'];
                if ~exist(fullfile(img_fdpth,testImgName),'file')
                    file_format_str = '%05d';
                end
            end

            
            for i_img = 1:NoSampleImg
                imgFileName = ['1_',...
                              num2str(imgIdx_slipCent+...
                              sampleImgIdx(i_img),file_format_str),...
                              '.tif'];
                subplot(NoRowPanel,NoRowPanel,i_img)
                try
                    if cropImg ==1 
                        Img = imread(fullfile(img_fdpth,imgFileName));
                        Img = imcrop(Img,cropRect);
                        imshow(Img)
                    else
                        imshow(fullfile(img_fdpth,imgFileName))
                    end
                    hold on
                    title(num2str(imgIdx_slipCent+sampleImgIdx(i_img)))
                catch
                end
            end
            %%
            uicontrol('Style','PushButton','String',"Yes",...
                'Units','normalized','Position',[0.60,0.02,0.18,0.06],...
                'Fontsize',12,'FontWeight','bold','Callback',...
                {@confirmRealSlip,SlipCents(i_slip)});
            uicontrol('Style','PushButton','String',"No",...
                'Units','normalized','Position',[0.8,0.02,0.18,0.06],...
                'Fontsize',12,'FontWeight','bold','Callback',...
                {@confirmFalseSlip,SlipCents(i_slip)});
            uicontrol('Style','text','String','Is it a slip?',...
                'Units','normalized','Position',[0.42,0.01,0.18,0.06],...
                'Fontsize',13,'FontWeight','normal');
            uiwait(gcf)
            clf
            N_falseSlip   = getappdata(gcf,'N_falseSlip');
            if N_falseSlip > 12
                break
            end
        end
    end
    %%
    N_realSlip    = getappdata(gcf,'N_realSlip');
    idx_realSlip  = getappdata(gcf,'idx_realSlip');
    N_falseSlip   = getappdata(gcf,'N_falseSlip');
    if N_falseSlip > 10; N_falseSlip = 9999; end
    idx_falseSlip = getappdata(gcf,'idx_falseSlip');
    close(gcf)
end

function confirmRealSlip(~,~,index)
    N_currentRealSlip = getappdata(gcf,'N_realSlip');
    N_currentRealSlip = N_currentRealSlip+1;
    setappdata(gcf,'N_realSlip',N_currentRealSlip);
    idx_realSlip = getappdata(gcf,'idx_realSlip');
    idx_realSlip = [idx_realSlip,index];
    setappdata(gcf,'idx_realSlip',idx_realSlip);
    uiresume(gcf);
end

function confirmFalseSlip(~,~,index)
    N_currentFalseSlip = getappdata(gcf,'N_falseSlip');
    N_currentFalseSlip = N_currentFalseSlip+1;
    setappdata(gcf,'N_falseSlip',N_currentFalseSlip);
    idx_falseSlip = getappdata(gcf,'idx_falseSlip');
    idx_falseSlip = [idx_falseSlip,index];
    setappdata(gcf,'idx_falseSlip',idx_falseSlip);
    uiresume(gcf);
end



