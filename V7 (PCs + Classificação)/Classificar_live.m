function n_img = Classificar_live(n_test, n_class, class)
    n_p_class = n_test/n_class;
    intervals(:, n_p_class) = 0;
    str_class = strcat(class(1), '-> (1-', string(n_p_class), ')\n');
    
    for j=1:n_class
        intervals(j) = n_p_class*j;
        if j > 1
            str_class = strcat(str_class, class(:, j), '-> (', string(intervals(j-1)+1), '-', string(intervals(j)), ')\n' );
        end
    end
    
    msg = strcat('Número da imagem para teste: \n', str_class);
    n_img = input(msg, 's');
    
    if (n_img > 0) & (n_img < (n_test+1))
        n_img = str2num(n_img);
    else
        disp("Número da Imagem fora do intervalo!");
        n_img = Classificar_live(n_test, n_class, class);
        %n_img = 1;
    end
end