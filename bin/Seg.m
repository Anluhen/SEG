function Seg(Diagrama, Modelo)

clc

tic;
%Se parou de funcionar é só voltar essa primeira parte pra como estava
dados = infoReader(Diagrama);  %Lê os dados do txt
[bloco, X, P, V, ini_var] = instanciate(dados);

toc;

bloco = swipe(bloco);

toc;

%Retira as informações dos limitadores
L = [];
for i = 1:length(bloco)
    if bloco{i}.tipo == "Limitador"
        L = [L bloco{i}.min bloco{i}.max bloco{i}.valorSaida];
    end
end
L = string(L);
L = erase(L,"(t)");

%Junta as equações obtidas na variável e
e = [];
for i = 1:length(bloco)
    if isprop(bloco{i},'eq')
        e = [e; bloco{i}.eq];
    end
end

toc;

%Transforma as equações diferenciais em espaço de estados (isolando as derivadas)
flag = 0;
while flag == 0
    
    for i = 1:length(e)
        for j = 1:length(e)
            if i~=j
                e(j) = subs(e(j), lhs(e(i)), rhs(e(i)));
            end
        end
    end
    
    for i = 1:length(e)
        if  all(ismember('diff(',char(rhs(e(i)))))
            flag = 0;
            break
        else
            flag = 1;
        end
    end
end

toc

e;

e_ini = initialConditions(e, ini_var);

toc;

%Escrever função que reescreva o arquivo do matdyn
if Modelo(1) == 'E' || Modelo(1) == 'e'
    writeExciter(Diagrama, e, X, P, V, L)
    writeExciterInit(Diagrama, e_ini, X, P, V, L)
elseif Modelo(1) == 'G' || Modelo(1) == 'g' || Modelo(1) == 'R' || Modelo(1) == 'r' || Modelo(1) == 'V' || Modelo(1) == 'v'
    writeGovernor(tipo, e, e_ini, X, P, V)
else
    fprintf(">>>>>>>>>>Could not identify a Matdyn model file type<<<<<<<<<<")
end

toc;

fprintf("\n>>DONE!\n")

%%Tentar pré-alocar espaço das variáveis e eiliminar todos os avisos
%%comentar todo o código
%%inserir mensagens de erros
end