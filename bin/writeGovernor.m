function F = writeGovernor(tipo, e, e_ini, X, P, V)

%%Cria o texto referente a parte a ser inserida no arquivo do Gov
for i=1:length(X)
    C{i} = sprintf('%s = Xgov(type%s,%d);', X(i), tipo, i); %Escreve as variáveis como Xgov
end
for i=1:length(P)
    i_old = length(C)+1;
    C{i_old} = sprintf('%s = Pgov(type%s,%d);', P(i), tipo, i+1); %Escreve as variáveis como Pgov
end
for i=1:length(V)
    i_old = length(C)+1;
    C{i_old} = sprintf('%s = Vgov(type%s,%d);', V(i), tipo, i); %Escreve as variáveis como Vgov
end
derivadas={};
for i=1:length(X)
    for j=1:length(e)
        left_s = erase(char(int(lhs(e(j)))),'(t)'); %Tira o (t) da symfun
        derivadas{j} = ['d',left_s]; %Escreve um vetor com as derivadas no formato dx
        if  left_s == X(i)
            i_old = length(C)+1;
            right_s = erase(char(rhs(e(j))),'(t)');
            right_s = replace(right_s, '*', '.*');
            right_s = replace(right_s, '/', './');
            C{i_old} = sprintf('d%s = %s;', left_s, right_s); %Escreve a equação dx = equação
        end
    end
end

i_old = length(C)+1;
C{i_old} = sprintf('F(type%s,1:%d) = [', tipo, length(derivadas));%Escreve % F(type3,1:2) = [dEfd dx];
for j = 1:length(derivadas)
    if j==1
        C{i_old} = [C{i_old} derivadas{j}];
    else
        C{i_old} = [C{i_old} ' ' derivadas{j}];
    end
end
C{i_old} = [C{i_old} '];'];

%Abre o arquivo existente
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Governors\Govervor.m');
govFile = [];
i=0;
while true
    line = fgetl(fileID);
    if line == -1
        break
    end
    i=i+1;
    govFile{i} = line;
end
fclose(fileID);

%%Procura o ponto de inserção do tipo
insertionStart = sprintf('%% Define governor types', tipo);
startIndex = 0;
for i = 1:length(govFile)
    if all(ismember(insertionStart,govFile{i}))
        startIndex = i;
    end
end

%Insere a linha do tipo
for i = 1:startIndex
    govOut{i} = govFile{i};
end

govOut{startIndex+1} = sprintf('type%s = d(govtype==%s);', tipo, tipo);

for i = 1:length(govFile)-startIndex
    govOut{length(govOut)+1} = govFile{startIndex+i};
end

govFile = govOut;

%%Procura o ponto de inserção
insertionStart = sprintf('Governor type %s', tipo);
startIndex = 0;
for i = 1:length(govFile)
    if all(ismember(insertionStart,govFile{i}))
        startIndex = i;
    end
end

%Insere a parte nova
for i = 1:startIndex
    govOut{i} = govFile{i};
end

for i = 1:length(C)
    govOut{startIndex+i} = C{i};
end

for i = 1:length(govFile)-startIndex
    govOut{length(govOut)+1} = govFile{startIndex+i};
end

%Sobrescreve o arquivo
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Governors\Govervor.m','w');
fclose(fileID);
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Governors\Govervor.m','a');
for i=1:length(govOut)
    fprintf(fileID, '%s\n', govOut{i});
end
fclose(fileID);

%%
%%Cria o texto referente a parte a ser inserida no arquivo do GovInit
C = {};
govOut = [];
X(1)= X(1)+'0';

for i=1:length(X(1))
    C{i} = sprintf('%s = Xgov(type%s,%d);', X(i), tipo, i); %Escreve as variáveis como Xgov
end
for i=1:length(P)-1
    i_old = length(C)+1;
    C{i_old} = sprintf('%s = Pgov(type%s,%d);', P(i), tipo, i+1); %Escreve as variáveis como Pgov
end
for i=1:length(V)
    i_old = length(C)+1;
    C{i_old} = sprintf('%s = Vgov(type%s,%d);', V(i), tipo, i); %Escreve as variáveis como Vgov
end

%Escreve as equações iniciais
for i=1:length(e_ini)
    i_old = length(C)+1;
    right_s = erase(char(rhs(e_ini(j))),'(t)');
    right_s = replace(right_s, '*', '.*');
    right_s = replace(right_s, '/', './');
    C{i_old} = sprintf('%s = %s;', lhs(e_ini(i)), right_s);
end

i_old = length(C)+1;
C{i_old} = sprintf('Xgov0(type%s,1:%d) = [', tipo, length(X));
for j = 1:length(X)
    if j==1
        C{i_old} = [C{i_old} X{j}];
    else
        C{i_old} = [C{i_old} ' ' X{j}];
    end
end
C{i_old} = [C{i_old} '];'];

i_old = length(C)+1;
C{i_old} = sprintf('Pgov0(type%s,1:%d) = [Pgov(type%s,1) ', tipo, length(P)+1, tipo);
for j = 1:length(P)
    if j==1
        C{i_old} = [C{i_old} P{j}];
    else
        C{i_old} = [C{i_old} ' ' P{j}];
    end
end
C{i_old} = [C{i_old} '];'];

%Abre o arquivo existente
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Governors\GovervorInit.m');
govFile = [];
i=0;
while true
    line = fgetl(fileID);
    if line == -1
        break
    end
    i=i+1;
    govFile{i} = line;
end
fclose(fileID);

%%Procura o ponto de inserção do tipo
insertionStart = sprintf('%% Define types', tipo);
startIndex = 0;
for i = 1:length(govFile)
    if all(ismember(insertionStart,govFile{i}))
        startIndex = i;
    end
end

%Insere a linha do tipo
for i = 1:startIndex
    govOut{i} = govFile{i};
end

govOut{startIndex+1} = sprintf('type%s = d(govtype==%s);', tipo, tipo);

for i = 1:length(govFile)-startIndex
    govOut{length(govOut)+1} = govFile{startIndex+i};
end

govFile = govOut;

%%Procura o ponto de inserção
insertionStart = sprintf('Governor type %s:', tipo);
startIndex = 0;
for i = 1:length(govFile)
    if all(ismember(insertionStart,govFile{i}))
        startIndex = i;
    end
end

%Insere a parte nova
for i = 1:startIndex
    govOut{i} = govFile{i};
end

for i = 1:length(C)
    govOut{startIndex+i} = C{i};
end

for i = 1:length(govFile)-startIndex
    govOut{length(govOut)+1} = govFile{startIndex+i};
end

%Sobrescreve o arquivo
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Governors\GovervorInit.m','w');
fclose(fileID);
fileID = fopen('D:\Programas\MATLAB\MatDyn1.2\Models\Governors\GovervorInit.m','a');
for i=1:length(govOut)
    fprintf(fileID, '%s\n', govOut{i});
end
fclose(fileID);

end