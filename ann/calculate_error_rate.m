function [ error_rate ] = calculate_error_rate(output, testY)
    error_count = 0;
    error_bool = 0;

    for i = 1: size(testY, 1)
        error_row = testY(i, :) - output(i, :);
        
        for j = 1: size(testY, 2)
            if error_row(1, j) ~= 0
                error_bool = 1;
            end
        end
        if error_bool ~= 0
            error_count = error_count +1;
        end
        error_bool = 0;
    end
    
    error_rate = error_count/size(testY, 1);
end

