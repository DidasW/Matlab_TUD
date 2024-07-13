% compile the interflagellar noise in phase
cd('D:\000 RAW DATA FILES\181129 noise tau');
AB00_experimentalConditions
if ~exist('slipRateTable','var')
    material_fdpth = fullfile('D:','SURFdrive folder','002 Academic writing',...
                 '180225 Manuscript for Cis-Trans difference',...
                 'material');
    load(fullfile(material_fdpth,'slipRateTable_allWTCells.mat'))
end
slipRateTable_b  = slipRateTable(...
                   strcmp(slipRateTable.beforePiezoFlow,...
                   'before'),:);
tauTable_PhUnwrapped = slipRateTable_b(:,[1:2,4:5,7:9,11:13]);
matfile_fdpth    = 'D:\000 RAW DATA FILES\181129 new phase\matfiles';

%% setting
segSize = 1000;

fo = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[0,0],'Upper',[100,segSize/2],...
    'StartPoint',[30,1]);
ft = fittype('A*exp(-x/tau)','options',fo);

%%
for i_cell = 1:size(slipRateTable_b,1)
    date = slipRateTable_b.date{i_cell};
    experiment = slipRateTable_b.experiment{i_cell};
    matfilepath = slipRateTable_b.phaseMatFilePath{i_cell};
    if ~isempty(matfilepath)
        if strcmp(date,'180710')
            caConc = slipRateTable_b.calciumConcentration(i_cell);
            if caConc == 0.005
                experiment = [experiment,'_5mMCa'];
            else
                experiment = [experiment,'_0.3mMCa'];
            end 
        end    
        experimentStr = [experiment,'_before'];
        newPhMatFile_pth = fullfile(matfile_fdpth,[experimentStr,'.mat']);
        load(newPhMatFile_pth,'Ph_interflag_interp','ThPh1',...
            'ThPh1_unwrapped','ThPh2_unwrapped','Fs')
        %%
        Ph_theory  = ThPh1_unwrapped - ThPh2_unwrapped;
        t_raw      = make_time_series(Ph_theory,Fs,'ms');
        t          = make_time_series(Ph_interflag_interp,1000,'ms');
        Ph_theory  = interp1(t_raw,Ph_theory,t);
        %%
        avg_corr = zeros(1,2*segSize-1);
        NoSeg = floor(numel(ThPh1)/segSize)-1;
        NoSeg_effect = NoSeg;

        %% figure setting  
        figure('defaulttextinterpreter','Latex')
        set(gca,'defaulttextinterpreter','Latex',...
            'TickLabelInterpreter','Latex')
        hold on, grid on, box on
        xlabel('t (ms)')
        ylabel('Auto-correlation (a.u.)')

        %% calc tau
        
        for i_seg = 1:NoSeg
            idx = segSize/2 +[(i_seg-1)*segSize+1  : i_seg*segSize];
            sample = Ph_theory(idx);
            if max(smooth(sample,60))-min(smooth(sample,60)) < 0.7
                sample    = sample - mean(sample);
                [C,lag]   = xcorr(sample);
                h_seg     = plot(lag,C,'-','color',[0.8,0.8,0.8],...
                            'LineWidth',0.5);
                avg_corr = avg_corr+C;
            else
                NoSeg_effect = NoSeg_effect-1;
                continue
            end
        end
        avg_corr   = avg_corr/NoSeg_effect;
        fit_expDec = fit(lag(lag>=0)',avg_corr(lag>=0)',ft);
        A      = fit_expDec.A;
        tau    = fit_expDec.tau;
        temp   = confint(fit_expDec);
        A_95ConfiRange   = temp(:,1); 
        tau_95ConfiRange = temp(:,2);
        if NoSeg_effect < 10
            A = nan; tau = nan; 
            A_95ConfiRange = []; tau_95ConfiRange= [];
        end
        clear temp

        %% figure setting
        title(sprintf('Segment: %dms |No. of Segment: %d',...
              segSize,NoSeg_effect));
        h_avg = plot  (lag,avg_corr,'o','color',BaoLan,...
               'MarkerFaceColor',BaoLan,'MarkerEdgeColor','none',...
               'LineWidth',1,'MarkerSize',2);
        h_fit = plot(fit_expDec(lag(lag>=0)),'--',...
                'LineWidth',1.5,'color',orange);
        legend([h_seg,h_avg,h_fit],{'autocorr, Each segment','average',...
               ['fit, exp{-t/$\tau$},$\tau$=',num2str(tau,'%.1f'),' ms']},...
               'Location','northeast','Box','off','Interpreter','latex',...
               'FontSize',10) 
        ylim  ([-0.1,max(avg_corr)*1.5])
        xlim  ([0,segSize/2]);

        %% save
        tauTable_PhUnwrapped(i_cell,11) = {newPhMatFile_pth};
        tauTable_PhUnwrapped{i_cell,12} = A;
        tauTable_PhUnwrapped(i_cell,13) = {A_95ConfiRange};
        tauTable_PhUnwrapped{i_cell,14} = tau;
        tauTable_PhUnwrapped(i_cell,15) = {tau_95ConfiRange};
        tauTable_PhUnwrapped{i_cell,16} = segSize;
        tauTable_PhUnwrapped{i_cell,17} = NoSeg_effect;

        %% savefig
        savefig(gcf,fullfile('figures_usingUnwrappedPhase',[experimentStr,'.fig']))
        if mod(i_cell,4) == 0
            close all
        end  
    end
end

tauTable_PhUnwrapped.Properties.VariableNames{11} = 'newPhaseMatFilePath';
tauTable_PhUnwrapped.Properties.VariableNames{12} = 'A';        
tauTable_PhUnwrapped.Properties.VariableNames{13} = 'A95ConfiRange';
tauTable_PhUnwrapped.Properties.VariableNames{14} = 'tau';
tauTable_PhUnwrapped.Properties.VariableNames{15} = 'tau95ConfiRange';
tauTable_PhUnwrapped.Properties.VariableNames{16} = 'segmentSize';
tauTable_PhUnwrapped.Properties.VariableNames{17} = 'numberOfSegments';
tauTable_PhUnwrapped = movevars(tauTable_PhUnwrapped,'newPhaseMatFilePath',...
                    'After','phaseMatFilePath');
save('noiseTauTable_usingUnwrappedPhase.mat','tauTable_PhUnwrapped')