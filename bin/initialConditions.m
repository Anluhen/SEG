function F = initialConditions(e, ini_var)

eAux = e;

for i = 1:length(eAux)
    eAux(i) = str2sym(erase(char(eAux(i)),'L(t)'));
    eAux(i) = str2sym(erase(char(eAux(i)),'(t)'));
end

for i = 1:length(e)
    try
        eAux(i) = isolate(eAux(i),ini_var(i));
    end

    for j = 1:length(eAux)
        for k = 1:length(eAux)
            if j~=k
                eAux(k) = subs(eAux(k), lhs(eAux(j)), rhs(eAux(j)));
            end
        end
    end
end

F = eAux;

end