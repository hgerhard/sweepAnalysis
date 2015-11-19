switch blah
    case '2DPhase'
        if iCmp == 1
            line( 0,0, 'LineStyle','none', 'Marker','+', 'MarkerSize',20, 'Color','k' )
        end
        [ tY, tYSubj, tNSbjs ] = getAvgSliceData( tAvgFlags, SD, tDomain, tValidFields, tSliceFlags );
        % tY is the mean vector over subjects; tYSubj contains each
        % subject's vector like Sr Si
        tX = real( tY );
        tY = imag( tY );
        if ~tAvgSbjs || IsAnyOptSel( 'Stats', 'Mean' )
            %								line(	tX, tY, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 15, ...
            %												'MarkerEdgeColor', tColorOrderMat( iColor, : ), 'MarkerFaceColor', tColorOrderMat( iColor, : ) )
            line(	[0 tX], [0 tY], 'Color', tColorOrderMat( iColor, : ), 'LineWidth', 2) %, 'Marker', '.', 'MarkerSize', 20 )
        end
        if tPlotDispersion
            tNellip = 30;
            tTh = linspace( 0, 2*pi, tNellip )';
            if IsOptSel( 'DisperScale', 'SEM' )
                tNormK = 1 / (tNSbjs-2);
            else % 95% CI
                tNormK = (tNSbjs-1)/tNSbjs/(tNSbjs-2) * finv( 0.95, 2, tNSbjs - 2 );
            end
            [ tEVec, tEVal ] = eig( cov( [ real( tYSubj ), imag( tYSubj ) ] ) );	% Compute eigen-stuff
            tXY = [ cos(tTh), sin(tTh) ] * sqrt( tNormK * tEVal ) * tEVec';		% Error/confidence ellipse
            tXY = tXY + repmat( [tX tY], tNellip, 1 );
            if IsOptSel( 'Patches', 'on' )
                % patches with transparent fills look great, but Matlab throws an error when trying to save them as AI files.
                patch( tXY(:,1), tXY(:,2), tColorOrderMat( iColor, : ), 'FaceAlpha', .25, 'EdgeColor', tColorOrderMat( iColor, : ), 'LineWidth', 2 );
            else
                % use the following when making AI files.
                line( tXY(:,1), tXY(:,2), 'Color', tColorOrderMat( iColor, : ), 'LineWidth', 2 );
            end
        end
        if tPlotScatter
            line( real(tYSubj), imag(tYSubj), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 15, ...
                'MarkerEdgeColor', tColorOrderMat( iColor, : ), 'MarkerFaceColor', tColorOrderMat( iColor, : ) );
        end
        
end
%%%

function tYbar = Std2ErrBar( tStd, tNSbjs )
switch GetOptSelx( 'DisperScale', 1 )
    case 'SEM'
        tYbar = tStd / sqrt( tNSbjs - 1 );
    case '95%CI'			% note how this differs from 2D-phase version, since we project into 1-D.
        tYbar = tStd * sqrt( finv( 0.95, 1, tNSbjs - 1 ) / tNSbjs );
    otherwise
        error('Unknown DisperScale.')
end
end