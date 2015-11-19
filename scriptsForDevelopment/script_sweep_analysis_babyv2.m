% Sweep Analysis Outline

exptNames = {'Disparity' 'Correlation'};
condNames = {'Horizontal' 'Vertical'};
channels = [71 76 70 75 83 74 82];
sweepEstType = 'RLS';
colors = linspace(0.2,0.7,7);
allColors = zeros(7,3,4);
allColors(:,3,1) = colors; % B
allColors(:,1,2) = colors; % R
allColors(:,2,3) = colors; % G
allColors(:,[1 3],4) = repmat(colors',[1 2]); % M
borderColors = {'b' 'r' 'g' 'm'};
sessInfo = dlmread('ProcData/SessionInfo_RedCap.csv',',');
condDescriptions = {'Corr 2Hz' 'Corr 3Hz' 'Disp 2Hz' 'Disp 3Hz'};

for modulationFreq = [2 3]
    
    for exptNum = 1:length(exptNames)
        exptType = exptNames{exptNum};
        
        dataDir = sprintf('~/Experiments/3DThresh/Data/Baby_%dHz/%s/',modulationFreq,exptType);
        subjDirs = dir([dataDir,'*TEXT_HCN*']);
        if ~isempty(subjDirs)
            for subjNum = 1:length(subjDirs)
                snum = str2double(subjDirs(subjNum).name(4:6));
                filename = sprintf('~/Experiments/3DThresh/Analysis/ProcData/Inf%d_%s_%dHz',snum,exptType,modulationFreq);
                
                subjDir = [dataDir,subjDirs(subjNum).name];
                
                pdMatFile = dir([filename,'.mat']);
                if isempty(pdMatFile) 
                    pdData = makeDataStructure(subjDir,channels,sweepEstType,exptType,condNames);
                else
                    load(filename);
                end
                
                if any(isnan(pdData(1,1).binLevels))
                    fprintf('ERROR! Did not export trial data for:\n%s.\n',filename);%###
                else
                    
                    dataHeaders = pdData(1).hdrFields; % hdrFields is the same for all conditions/electrodes
                    
                    % First page of plot document for this subject:
                    plot(1,1,'ko')
                    % get age info for this session:
                    condDescNum = find(strcmp([exptType(1:4) ' ' num2str(modulationFreq) 'Hz'],condDescriptions));
                    sessInfoIx = find(sessInfo(:,1)==snum & sessInfo(:,3)==condDescNum);
                    sAgeMos = sessInfo(sessInfoIx,2);
                    
                    % print out some info about the session
                    text(10,1,sprintf('Infant %d (@%1.1f mos.)\n %d Hz %s Sweep',snum,sAgeMos,modulationFreq,exptType),'FontSize',24)
                    text(10,0.8,'Horizontal Disparity','Color','b','FontSize',18)
                    text(10,0.7,'Vertical Disparity','Color','r','FontSize',18)
                    xlim([9,50])
                    axis off
                    print('-dpsc', '-append', sprintf('~/Experiments/3DThresh/Analysis/InfantData_%s_%d.ps',exptType,modulationFreq))
                    close(gcf)
                    
                    %  PD style sweep plots arranged hexagonally
                    s = 0.25;
                    b = 0.1;
                    subplotLoc = [ s/2+b s*2+2*b-.005 s s; ...
                        (s/2)+s+2*b s*2+2*b-.005 s s; ...
                        
                        4*b/5     s+5*b/4 s s; ...
                        s+8*b/5+0.002    s+5*b/4 s s; ...
                        2*s+5*b/2 s+5*b/4 s s; ...
                        
                        s/2+b b/2 s s; ...
                        (s/2)+s+2*b b/2 s s;];
                    
                    for freqNum = 1:length(pdData(1,1).avFreqs)
                        figNum = 1;
                        for chanNum = 1:length(channels)
                            
                            condNum = 1;
                            figNum = plotSweepPD( pdData(condNum,chanNum).dataMatr, [], ...
                                dataHeaders, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum},[figNum,subplotLoc(chanNum,:)] );
                            
                            condNum = 2;
                            plotSweepPD( pdData(condNum,chanNum).dataMatr, [], ...
                                dataHeaders, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum}, [figNum,subplotLoc(chanNum,:)]);
                            
                            if strcmp(exptType,'Disparity')
                                xlim([0 70])
                                set(gca,'XTick',[4 8 16 32 64])
                                set(gca,'XTick',[4 8 16 32 64])
                            end
                            set(gca,'YTick',[0 max(ylim)/4 max(ylim)/2 3*max(ylim)/4 max(ylim)])
                            text(pdData(condNum,chanNum).binLevels(end)-0.1,max(ylim)-(max(ylim)/10),num2str(channels(chanNum)),'FontSize',14)
                            text(pdData(condNum,chanNum).binLevels(1),max(ylim)-(max(ylim)/10),pdData(condNum,chanNum).avFreqs{freqNum},'FontSize',10)
                            xlabel('')
                            ylabel('')
                            if chanNum>1
                                title('')
                            end
                            
                        end
                        print('-dpsc', '-append', sprintf('~/Experiments/3DThresh/Analysis/InfantData_%s_%d.ps',exptType,modulationFreq))
                        close(figNum);
                    end
                    
                    %  SNR plots hexagonally
                    for freqNum = 1:length(pdData(1,1).avFreqs)
                        figNum = 1;
                        for chanNum = 1:length(channels)
                            
                            condNum = 1;
                            figNum = plotSnrPD( pdData(condNum,chanNum).dataMatr, [], ...
                                dataHeaders, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum},[figNum,subplotLoc(chanNum,:)] );
                            
                            condNum = 2;
                            plotSnrPD( pdData(condNum,chanNum).dataMatr, [], ...
                                dataHeaders, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum}, [figNum,subplotLoc(chanNum,:)]);
                            
                            if strcmp(exptType,'Disparity')
                                xlim([0 70])
                                set(gca,'XTick',[4 8 16 32 64])
                                set(gca,'XTick',[4 8 16 32 64])
                            end
                            set(gca,'YTick',[0 max(ylim)/4 max(ylim)/2 3*max(ylim)/4 max(ylim)])
                            text(pdData(condNum,chanNum).binLevels(end)-0.1,max(ylim)-(max(ylim)/10),num2str(channels(chanNum)),'FontSize',14)
                            text(pdData(condNum,chanNum).binLevels(1),max(ylim)-(max(ylim)/10),pdData(condNum,chanNum).avFreqs{freqNum},'FontSize',10)
                            
                            xlabel('')
                            ylabel('')
                            if chanNum>1
                                title('')
                            end
                            
                        end
                        
                        print('-dpsc', '-append', sprintf('~/Experiments/3DThresh/Analysis/InfantData_%s_%d.ps',exptType,modulationFreq))
                        close(figNum);
                    end
                    
                    %  Trial Number plots hexagonally
                    freqNum = 1;
                    for condNum = 1:2
                        for chanNum = 1:length(channels)
                            figNum = condNum;
                            
                            plotNumTrials( pdData(condNum,chanNum).dataMatr, [], ...
                                dataHeaders, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum},[figNum,subplotLoc(chanNum,:)] );
                            xlim([0 11])
                            
                            xlabel('')
                            set(gca,'XTickLabel','')
                            ylabel('')
                            if chanNum>1
                                title('')
                                set(gca,'YTickLabel','')
                            end
                            
                        end
                        print('-dpsc', '-append', sprintf('~/Experiments/3DThresh/Analysis/InfantData_%s_%d.ps',exptType,modulationFreq))
                        close(figNum);
                    end
                    cd('~/Experiments/3DThresh/Analysis')
                    save(filename,'pdData');
                    clear pdData
                end
            end
        end
    end
end
