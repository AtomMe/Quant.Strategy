%将股票代码转换为股票文件名  eg. 600000.SH转换为SH600000
%返回字符串
function [codeFilename] = Code2Filename(Code)
    prefix = Code(1:end-3);
    postfix = Code(end-1:end);
    codeFilename = strcat(postfix,prefix);
end
