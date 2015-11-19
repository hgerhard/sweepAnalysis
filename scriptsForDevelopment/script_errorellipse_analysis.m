
%% example dataset:
load('~/Experiments/NoiseMaskTypical_fromFrancesca/Project_Exp_TEXT_HCN_128_Avg/RLS.mat')
% these data contain only electrode 75

%% grab example bin data:
binNum = 10;
condNum = 1;
freqNum = 1;

myData = pdData(condNum).dataMatr; 
colHdr = pdData(condNum).hdrFields;
%% get column indices
for k = 1:length(colHdr)
    switch colHdr{k}
        case 'iCond'
            condIx = k;
        case 'iTrial'
            trialIx = k;
        case 'iCh'
            chanIx = k;
        case 'iFr'
            freqIx = k;
        case 'iBin'
            binIx = k;
        case 'Sr'
            srIx = k;
        case 'StdErr'
            stdErrIx = k;
        case 'Si'
            siIx = k;
        case 'ampl'
            amplIx = k;
        case 'SNR'
            SNRIx = k;
        case 'Noise'
            noiseIx = k;
    end
end
%%
myData = myData(myData(:,freqIx)==freqNum,:);
myData = myData(myData(:,binIx)==binNum,:);

%%
actSubjIx = 2:36; % there are 36 Ss in this data set and the 1st entry is the avg. subj.
%%
figure; hold on;
plot(myData(actSubjIx,srIx),myData(actSubjIx,siIx),'ko')
axis equal;
line([0 0],[min(ylim) max(ylim)],'Color','k')
line([min(xlim) max(xlim)],[0 0],'Color','k')
%%
meanS = mean([myData(actSubjIx,srIx),myData(actSubjIx,siIx)]);
line([0 meanS(1)],[0 meanS(2)],'Color','k','LineWidth',2);
%%
xyData = [myData(actSubjIx,srIx),myData(actSubjIx,siIx)];
[errorEllipse,amplErrorRange] = getErrorEllipse(xyData,false,'SEM',true);

%% notes on plotting vectors with variables inside of getErrorEllipse:
plot(errorEllipse(:,1) + meanXy(1), errorEllipse(:,2) + meanXy(2),'r-','LineWidth',2) % ellipse
line([0 meanXy(1)],[0 meanXy(2)],'Color','k','LineWidth',4); % mean vector
text(meanXy(1),meanXy(2),num2str(norm(meanXy)),'FontSize',18)


plot([0 a.*largest_eigenvec(1)+meanXy(1)],[0 a.*largest_eigenvec(2)+meanXy(2)],'g-','LineWidth',2) % vector to major axis end 1
text(a.*largest_eigenvec(1)+meanXy(1), a.*largest_eigenvec(2)+meanXy(2),num2str(norm([a.*largest_eigenvec(1)+meanXy(1) a.*largest_eigenvec(2)+meanXy(2)])),'FontSize',18)

plot([0 -a.*largest_eigenvec(1)+meanXy(1)],[0 -a.*largest_eigenvec(2)+meanXy(2)],'g-','LineWidth',2) % vector to major axis end 2
text(-a.*largest_eigenvec(1)+meanXy(1), -a.*largest_eigenvec(2)+meanXy(2),num2str(norm([-a.*largest_eigenvec(1)+meanXy(1) -a.*largest_eigenvec(2)+meanXy(2)])),'FontSize',18)

plot([0 b.*smallest_eigenvec(1)+meanXy(1)],[0 b.*smallest_eigenvec(2)+meanXy(2)],'b-','LineWidth',2) % vector to minor axis end 1
text(b.*smallest_eigenvec(1)+meanXy(1), b.*smallest_eigenvec(2)+meanXy(2),num2str(norm([b.*smallest_eigenvec(1)+meanXy(1), b.*smallest_eigenvec(2)+meanXy(2)])),'FontSize',18)

plot([0 -b.*smallest_eigenvec(1)+meanXy(1)],[0 -b.*smallest_eigenvec(2)+meanXy(2)],'b-','LineWidth',2) % vector to minor axis end 2
text(-b.*smallest_eigenvec(1)+meanXy(1), -b.*smallest_eigenvec(2)+meanXy(2),num2str(norm([-b.*smallest_eigenvec(1)+meanXy(1), -b.*smallest_eigenvec(2)+meanXy(2)])),'FontSize',18)

plot([meanXy(1) a.*largest_eigenvec(1)+meanXy(1)],[meanXy(2) a.*largest_eigenvec(2)+meanXy(2)],'r-','LineWidth',2) % half major axis (1)
plot([meanXy(1) -a.*largest_eigenvec(1)+meanXy(1)],[meanXy(2) -a.*largest_eigenvec(2)+meanXy(2)],'r-','LineWidth',2) % half major axis (2)
plot([meanXy(1) b.*smallest_eigenvec(1)+meanXy(1)],[meanXy(2) b.*smallest_eigenvec(2)+meanXy(2)],'r-','LineWidth',2) % half minor axis (1)
plot([meanXy(1) -b.*smallest_eigenvec(1)+meanXy(1)],[meanXy(2) -b.*smallest_eigenvec(2)+meanXy(2)],'r-','LineWidth',2) % half minor axis (2)


%%
cov([myData(actSubjIx,srIx),myData(actSubjIx,siIx)])
[eigenvec, eigenval ] = eig(cov([myData(actSubjIx,srIx),myData(actSubjIx,siIx)]));

[orderedVals,eigAscendIx] = sort(diag(eigenval));
smallest_eigenvec = eigenvec(:,eigAscendIx(1)); 
largest_eigenvec = eigenvec(:,eigAscendIx(2));
smallest_eigenval = orderedVals(1);
largest_eigenval = orderedVals(2);

% Calculate the angle between the x-axis and the largest eigenvector
phi = atan2(largest_eigenvec(2), largest_eigenvec(1));
% This angle is between -pi and pi.
% Let's shift it such that the angle is between 0 and 2pi
if(phi < 0)
    phi = phi + 2*pi;
end

ciSz = .68;
chisquare_val = chi2inv(ciSz,2);
theta_grid = linspace(0,2*pi);
X0=meanS(1);
Y0=meanS(2);
% ChiSq version:
a=sqrt(chisquare_val*largest_eigenval);
b=sqrt(chisquare_val*smallest_eigenval);

%SEM?
a = sqrt(largest_eigenval/sqrt(36));
b = sqrt(smallest_eigenval/sqrt(36));

%Hotelling's t-squared:
numSubjs = 36;
Tsq = ((numSubjs-1)*2)/(numSubjs-2) * finv( ciSz, 2, numSubjs - 2 );
a = sqrt(largest_eigenval*Tsq);
b = sqrt(smallest_eigenval*Tsq);

% the ellipse in x and y coordinates 
ellipse_x_r  = a*cos( theta_grid );
ellipse_y_r  = b*sin( theta_grid );

%Define a rotation matrix
R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];

%let's rotate the ellipse to some angle phi
r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;

% Draw the error ellipse
plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'-')
hold on;

plot([meanS(1) smallest_eigenvec(1)+meanS(1)],[meanS(2) smallest_eigenvec(2)+meanS(2)],'g-')
plot([meanS(1) sqrt(smallest_eigenval).*smallest_eigenvec(1)+meanS(1)],[meanS(2) sqrt(smallest_eigenval).*smallest_eigenvec(2)+meanS(2)],'g-')

plot([meanS(1) largest_eigenvec(1)+meanS(1)],[meanS(2) largest_eigenvec(2)+meanS(2)],'m-')
plot([meanS(1) sqrt(largest_eigenval).*largest_eigenvec(1)+meanS(1)],[meanS(2) sqrt(largest_eigenval).*largest_eigenvec(2)+meanS(2)],'m-')

