function J = MSE(p)
    % Função de Custo (Erro Quadrático Médio)
    % p = [K, zeta, wn]

    K_est = p(1);
    zeta_est = p(2);
    wn_est = p(3);

    % --- PROTEÇÃO (PENALIDADE) ---
    % O modelo matemático "subamortecido" só funciona se 0 <= zeta < 1.
    % Se o fminsearch tentar sair dessa faixa, retornamos um erro infinito.
    if zeta_est >= 1 || zeta_est < 0 || wn_est < 0
        J = 1e20; % Penalidade altíssima ("Muro Infinito")
        return;   % Sai da função antes de dar erro matemático
    end

    % Acessa as variáveis globais
    global tempo_global u_degrau_global ym_global

    % Gera a resposta esperada
    ym_esp = subamortecido(tempo_global, u_degrau_global, K_est, zeta_est, wn_est);

    % Calcula o erro
    erro = ym_global - ym_esp;
    J = mean(erro.^2);
end
