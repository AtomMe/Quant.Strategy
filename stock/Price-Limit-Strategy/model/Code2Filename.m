%����Ʊ����ת��Ϊ��Ʊ�ļ���  eg. 600000.SHת��ΪSH600000
%�����ַ���
function [codeFilename] = Code2Filename(Code)
    prefix = Code(1:end-3);
    postfix = Code(end-1:end);
    codeFilename = strcat(postfix,prefix);
end
