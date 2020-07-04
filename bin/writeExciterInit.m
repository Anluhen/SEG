function writeExciterInit(model, e_ini, X, P, V, L)

%%Abre o arquivo existente
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Exciters\ExciterInit.m');
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
insertionStart = '%% Define types';
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

%%Cria o texto referente a parte a ser inserida no arquivo do ExcInit
C{1} = '';
C{2} = sprintf('%s Exciter type %s: %s', "%%", tipo, model);

% for i=1:length(X)
    i_old = length(C)+1;
    C{i_old} = sprintf('%s = Xexc(type%s,1);', X(1), tipo); %Escreve as variáveis como Xexc
% end

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

C{length(C)+1} = '';

for i=1:length(V)
    i_old = length(C)+1;
    C{i_old} = sprintf('%s = Vexc(type%s,%d);', V(i), tipo, i); %Escreve as variáveis como Vexc
end

C{length(C)+1} = '';

%Escreve as equações iniciais
for i=1:length(e_ini)
    i_old = length(C)+1;
    right_s = erase(char(rhs(e_ini(i))),'(t)');
    right_s = replace(right_s, '*', '.*');
    right_s = replace(right_s, '/', './');
    C{i_old} = sprintf('%s = %s;', lhs(e_ini(i)), right_s);
end

C{length(C)+1} = '';

i_old = length(C)+1;
C{i_old} = sprintf('Xexc0(type%s,1:%d) = [', tipo, length(X));
for j = 1:length(X)
    if j==1
        C{i_old} = sprintf('%s%s',C{i_old}, X{j});
    else
        C{i_old} = sprintf('%s, %s',C{i_old}, X{j});
    end
end
C{i_old} = [C{i_old} '];'];

i_old = length(C)+1;
C{i_old} = sprintf('Pexc0(type%s,1:%d) = [Pexc(type%s,1)', tipo, length(P)+1+2*length(L)/3, tipo);
for j = 1:length(P)-1
    C{i_old} = [C{i_old} ', ' P{j}];
end
for j = 1:3:length(L)
    C{i_old} = [C{i_old} ', ' L{j}];
    C{i_old} = [C{i_old} ', ' L{j+1}];
end
C{i_old} = [C{i_old} ', ' P{length(P)}];
C{i_old} = [C{i_old} '];'];

C{length(C)+1} = '';

%%Procura o ponto de inserção do tipo
insertionStart = '%% Define types';
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

%Insere a linha do tipo
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
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Exciters\ExciterInit.m','w');
fclose(fileID);
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Exciters\ExciterInit.m','a');

for i=1:length(excOut)
    fprintf(fileID, '%s\n', excOut{i});
end

fclose(fileID);

end