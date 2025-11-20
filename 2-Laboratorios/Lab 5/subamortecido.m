function y = subamortecido(tempo, u_amplitude, K, zeta, wn)
    % Calcula a resposta ao degrau de um sistema subamortecido de 2a ordem

    % Garante que o termo dentro da raiz não seja negativo por erro numérico
    termo_raiz = 1 - zeta^2;
    if termo_raiz < 0
        termo_raiz = 0;
    end

    beta = sqrt(termo_raiz);
    wd = wn * beta;

    % Pre-aloca
    y = zeros(length(tempo), 1);

    phi = atan2(beta, zeta); % Angulo de fase

    for k = 1:length(tempo)
        t = tempo(k);
        if t >= 0
            decay = exp(-zeta * wn * t);
            oscillation = sin(wd * t + phi);

            % Evita divisão por zero se beta for muito pequeno
            if beta < 1e-6
                 y(k) = u_amplitude * K * (1 - decay * (1 + wn*t)); % Aproximação crítica
            else
                 y(k) = u_amplitude * K * (1 - (decay / beta) * oscillation);
            end
        else
            y(k) = 0;
        end
    end
end
