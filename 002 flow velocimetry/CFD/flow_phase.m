%Calculate actual phase difference between flow and cell
if strcmp(scenario,'Base case') == 0
    phasediff_act = cell(datasets,3);   %Phase difference between flow and cell
    phasediff_flag = cell(datasets);    %Phase difference between flagella
    meanphasediff_act = zeros(datasets,1);
    %Calculate actual phase difference between flow and cell
    for dd=1:datasets
        %Subtract an entire number of periods from the phase of the flow
        temp2 = mod(flow.phi{dd}(begimg(dd)),2*pi);
        temp3 = flow.phi{dd}(begimg(dd):enimg(dd))-flow.phi{dd}(begimg(dd))+temp2; 
        if strcmp(scenario,'Shift') == 1
           temp3 = temp3 + pi; %Shift the flow by pi so I dont have to do all
           %experiments again :P
        end
        phasediff_act{dd,1} = phicell{dd,1}-temp3';
        phasediff_act{dd,2} = phicell{dd,2}-temp3';
        phasediff_act{dd,3} = (phasediff_act{dd,1}+phasediff_act{dd,2})./2;
        meanphasediff_act(dd) = mean(phasediff_act{dd,3}); 
        phasediff_flag{dd} = phicell{dd,1}-phicell{dd,2};
        for lr=1:2
            GIPphasediff_act{dd,lr} = griddedInterpolant(dataind{dd},phasediff_act{dd,lr},GIPmethod);
            for kk=1:avgbeat{dd,lr}.nperiods %Calculate average phase diff per cycle
                phasediff_act_cyc{dd,lr}(kk,1) = mean(GIPphasediff_act{dd,lr}(linspace(...
                    avgbeat{dd,lr}.locs(kk),avgbeat{dd,lr}.locs(kk+1),50)));
            end
        end
    end
    a = ceil(sqrt(datasets));   b = ceil(datasets/a);
    %-------------------------------------------
    % Plot phase difference between flagella
    %-------------------------------------------
    % figure,hold on
    % for dd=1:datasets
    %     subplot(a,b,dd),hold on
    %     h=plot(phasediff_flag{dd},'k');
    %     legend(h,name{dd})
    % end
    % %Plot phase difference between flow and cell
    % figure,hold on
    % for dd=1:datasets
    %     subplot(a,b,dd),hold on
    %     h=plot(phasediff_act{dd,1},'r');
    %     plot(phasediff_act{dd,2},'g')
    %     legend(h,name{dd})
    % end
    
    %-------------------------------------------
    % Plot flow phase vs cell phase
    %-------------------------------------------
%     figure,hold on
%     for dd=1:datasets
%         subplot(a,b,dd),hold on
%         h=plot(mod(flow.phi{dd}(beginimg:endimg),2*pi),'k');
%         plot(mod(phicell{dd,1},2*pi),'r')
%         plot(mod(phicell{dd,2},2*pi),'g')
%         axis([0 100 0 2*pi])
%         legend(h,name{dd})
%     end

    %-------------------------------------------
    % Plot flow velocity vs cell phase
    %-------------------------------------------
    % figure,hold on
    % for dd=1:datasets
    %     subplot(a,b,dd),hold on
    %     x   = dataind{dd}';
    %     y1  = flow.vel(dd,:)';
    %     y2  = mod(phicell{dd,1},2*pi)./pi;
    %     y3  = mod(phicell{dd,2},2*pi)./pi;
    %     plotyy(x,y1,[x' x'],[y2' y3'])
    %     legend(name{dd}),grid on
    % end
    
    %-------------------------------------------
    % Plot flow velocity vs flow phase
    %-------------------------------------------
%     figure,hold on
%     for dd=1:datasets
%         subplot(a,b,dd),hold on
%         x   = dataind{dd}';
%         y1  = flow.vel(dd,:)';
%         y2  = mod(flow.phi{dd}(beginimg:endimg),2*pi);
%         [H,AX1,AX2]=plotyy(x,y1,x',y2');
%         set(H(1),'xlim',[0 100])
%         set(H(2),'xlim',[0 100])
%         legend(name{dd}),grid on
%     end
end