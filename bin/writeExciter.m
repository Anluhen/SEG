function writeExciter(model, e, X, P, V, L)

%%Abre o arquivo existente
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Exciters\Exciter.m');
excFile = [];
i=0;
while true
    line = fgetl(fileID);
    if line == -1
        break
    end
    i=i+1;
    excFile{i} = line;
end

fclose(fileID);

%%Define o número do modelo para uso do Matdyn
insertionStart = '%% Define exciter types';
for i = 1:length(excFile)
    if all(ismember(insertionStart,excFile{i}))
        startIndex = i;
    end
end

i = 1;
flag = 0;
while flag ==0
    if ~all(ismember('d(exctype==', excFile{startIndex+i}))
        tipo = sprintf("%d",i);
        flag = 1;
    else
        i = i+1;
    end
end

model = erase(model,'.txt');

%%Cria o texto referente a parte a ser inserida no arquivo do Exc
C{1} = '';
C{2} = sprintf('%s Exciter type %s: %s', "%%", tipo, model);

for i=1:length(X)
    i_old = length(C)+1;
    C{i_old} = sprintf('%s = Xexc(type%s,%d);', X(i), tipo, i); %Escreve as variáveis como Xexc
end

C{length(C)+1} = '';

for i=1:length(P)-1
    i_old = length(C)+1;
    C{i_old} = sprintf('%s = Pexc(type%s,%d);', P(i), tipo, i+1); %Escreve as variáveis como Pexc
    Pexcsize = i+1;
end
for i=1:3:length(L)
    i_old = length(C)+1;
    C{i_old} = sprintf('%s = Pexc(type%s,%d);', L(i), tipo, Pexcsize+1); %Escreve as variáveis como Pexc
    i_old = length(C)+1;
    Pexcsize = Pexcsize+1;
    C{i_old} = sprintf('%s = Pexc(type%s,%d);', L(i+1), tipo, Pexcsize+1);
    Pexcsize = Pexcsize+1;
end
C{length(C)+1} = sprintf('%s = Pexc(type%s,%d);', P(length(P)), tipo, Pexcsize+1); %Escreve as variáveis como Pexc
C{length(C)+1} = '';

for i=1:length(V)
    i_old = length(C)+1;
    C{i_old} = sprintf('%s = Vexc(type%s,%d);', V(i), tipo, i); %Escreve as variáveis como Vexc
end

C{length(C)+1} = '';

%%Escreve os limitadores das variáveis
i = 1;
while i<=length(L)
    C{length(C)+1} = sprintf('if %s > %s',  erase(L(i+2),'L'), L(i+1));
    C{length(C)+1} = sprintf('    %s = %s;', L(i+2), L(i+1));    
    C{length(C)+1} = sprintf('elseif %s < %s',  erase(L(i+2),'L'), L(i));   
    C{length(C)+1} = sprintf('    %s = %s;', L(i+2), L(i));
    C{length(C)+1} = 'else';   
    C{length(C)+1} = sprintf('    %s = %s;', L(i+2), erase(L(i+2),'L'));
    C{length(C)+1} = 'end';
    C{length(C)+1} = '';
    i = i+3;
end

%%Escreve as equações
for i=1:length(X)
    for j=1:length(e)
        left_s = erase(char(int(lhs(e(j)))),'(t)'); %Tira o (t) da symfun
        if  left_s == X(i)
            i_old = length(C)+1;
            right_s = erase(char(rhs(e(j))),'(t)');
            %%Coloca '.' antes dos operadores não matriciais
            right_s = replace(right_s, '*', '.*');
            right_s = replace(right_s, '/', './');
            C{i_old} = sprintf('d%s = %s;', left_s, right_s); %Escreve a equação dx = equação
        end
    end
end

C{length(C)+1} = '';

%%Zera os valores das derivadas non-windup
i = 1;
while i<=length(L)
    C{length(C)+1} = sprintf('if %s > %s',  erase(L(i+2),'L'), L(i+1));
    C{length(C)+1} = sprintf('    d%s = 0;', erase(L(i+2),'L'));    
    C{length(C)+1} = sprintf('elseif %s < %s',  erase(L(i+2),'L'), L(i));   
    C{length(C)+1} = sprintf('    d%s = 0;', erase(L(i+2),'L'));
    C{length(C)+1} = 'end';
    C{length(C)+1} = '';
    i = i+3;
end

i_old = length(C)+1;
C{i_old} = sprintf('F(type%s,1:%d) = [', tipo, length(X));%Escreve % F(type3,1:2) = [dEfd dx];
for j = 1:length(X)
    if j==1
        C{i_old} = sprintf('%sd%s',C{i_old}, X{j});
    else
        C{i_old} = sprintf('%s, d%s',C{i_old}, X{j});
    end
end
C{i_old} = [C{i_old} '];'];

C{length(C)+1} = '';

%%Procura o ponto de inserção do tipo
insertionStart = '%% Define exciter types';
for i = 1:length(excFile)
    if all(ismember(insertionStart,excFile{i}))
        startIndex = i;
    end
end

i = 1;
flag = 0;
while flag ==0
    if ~all(ismember('d(exctype==', excFile{startIndex+i}))
        startIndex = startIndex + i;
        flag = 1;
    else
        i = i+1;
    end
end

%%Insere a linha do tipo
for i = 1:startIndex
    excOut{i} = excFile{i};
end

excOut{startIndex} = sprintf('type%s = d(exctype==%s);', tipo, tipo);
excOut{startIndex+1} = '';

for i = 1:length(excFile)-startIndex
    excOut{length(excOut)+1} = excFile{startIndex+i};
end

%%Procura o ponto de inserção
insertionStart = 'return;';
for i = length(excFile):-1:1
    if all(ismember(insertionStart,excFile{i}))
        startIndex = i-1;
        break
    end
end

%%Insere a parte nova
for i = 1:length(C)
    excOut{startIndex+i} = C{i};
end

for i = 1:length(excFile)-startIndex
    excOut{length(excOut)+1} = excFile{startIndex+i};
end

%%Sobrescreve o arquivo
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Exciters\Exciter.m','w');
fclose(fileID);
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Exciters\Exciter.m','a');

for i=1:length(excOut)
    fprintf(fileID, '%s\n', excOut{i});
end

fclose(fileID);

end