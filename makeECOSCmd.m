function makeECOSCmd(c, G, h, dims, A, b)
% =============================================================
% makeECOSCmd generates codes for ECOS in C language.
%         For definition of the input, see ECOS documents.
%         The output is the generated code, in strings,
%         which are similar to those in <data.h> of ECOS
%
% This script is coded by Kuang (c) 2023.
% =============================================================

    [Apt, Air, Ajc] = mat2SparseCCS(A);
    [Gpt, Gir, Gjc] = mat2SparseCCS(G);
    
    cmdStr = strings(15, 1);
    varNames = ["n"; "m"; "p"; "l"; 
                "ncones"; "c"; "h"; "q"; 
                "Gjc"; "Gir"; "Gpr"; "Ajc"; 
                "Air"; "Apr"; "b"];
    varTypes = ["idxint"; "idxint"; "idxint"; "idxint"; 
                "idxint"; "pfloat"; "pfloat"; "idxint"; 
                "idxint"; "idxint"; "pfloat"; "idxint"; 
                "idxint"; "pfloat"; "pfloat"];
    varContents = {length(c); length(h); length(b); dims.l; length(dims.q); c; h; dims.q; Gjc; Gir; Gpt; Ajc; Air; Apt; b};

    for i = 1:length(cmdStr)
        cmdStr(i) = makeECOSLineCmd(varNames(i), varTypes(i), varContents{i});
        fprintf("%s\n", cmdStr(i));
    end

end

function lineCmd = makeECOSLineCmd(varName, varType, varContents)
    switch varType
        case "idxint"
            if length(varContents) == 1
                lineCmd = sprintf("%s %s = ", varType, varName) + sprintf("%d", varContents(1)) + ";";
            else
                lineCmd = sprintf("%s %s[%d] = {", varType, varName, length(varContents)) + sprintf("%d, ", varContents(1:end-1)) + sprintf("%d", varContents(end)) + "};";   
            end

        case "pfloat"
            if length(varContents) == 1
                lineCmd = sprintf("%s %s = ", varType, varName) + sprintf("%e", varContents(1)) + ";";
            else
                lineCmd = sprintf("%s %s[%d] = {", varType, varName, length(varContents)) + sprintf("%e, ", varContents(1:end-1)) + sprintf("%e", varContents(end)) + "};";
            end
    end
end

function [pt, ir, jc] = mat2SparseCCS(A)  
    % pt: nonzero elements in A
    % ir: row of the nonzero elements
    % jc: See description in https://ww2.mathworks.cn/help/matlab/apiref/mxsetjc.html
    [ir, ~, pt] = find(A);
    ir = ir - 1;

    jc = zeros(size(A,2) + 1, 1);
    jc(end) = length(pt);
    for i = 2:size(A,2)
        jc(i) = nnz(A(:,i-1)) + jc(i-1);
    end

end
