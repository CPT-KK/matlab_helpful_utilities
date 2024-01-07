function varargout = fig2pdf( varargin )
% =============================================================
% fig2eps finds all *.fig files in the current MATLAB path and
%         converts them to *.pdf files.
%         Beware: Any *.pdf files with the same name in the 
%         current MATLAB path WILL BE COVERED !
% 
% fig2eps 找到当前 MATLAB 目录下所有的fig图，并将其转化为边距很窄的 pdf 文件。
%         注意：当前 MATLAB 目录下的所有重名 *.pdf 文件将被覆盖！
% 
% This script is coded by Kuang (c) 2022.
% =============================================================

switch nargin
    case 0
        % Read *.fig in currnet path
        figDir = [cd, '\'];
        figDirStructure = dir('*.fig');
        figNum = length(figDirStructure);
        
        % Is anything found?
        if figNum == 0
            error('fig2eps:NoFigFileFound',"No *.fig is found in current path.")
        end

        figFileList = strings(figNum,1);
        for i = 1:figNum
            figFileList(i) = [figDir, figDirStructure(i).name];
        end

    otherwise
        figNum = nargin;
        figFileList = strings(figNum,1);
        for i = 1:nargin
            figFileList(i) = varargin{i};
        end
end

% Start converting
fprintf("[INFO] Found [%d] *.fig file(s), preparing to convert......\n", figNum);
for i = 1:figNum
    fprintf("[%d/%d] Converting [%s]......", i, figNum, figFileList(i));
    figToPrint = openfig(figFileList(i), 'invisible');
    fprintf("Done!\n");
    desFileName = strrep(figFileList(i), '.fig', '.pdf');
%     print(figToPrint, desFileName, '-depsc', '-vector')
    exportgraphics(figToPrint, desFileName, ContentType="vector");
end
fprintf("[INFO] Convertion completed.\n");


varargout{1} = 1;
end
