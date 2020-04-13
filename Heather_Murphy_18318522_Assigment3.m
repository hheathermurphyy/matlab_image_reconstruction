close all
clear 

% Read in the picture
original = double(imread('greece.tif'));

% Read in the magic forcing function
load forcing;  

% Read in the corrupted picture which contains holes
load badpicture;

% Read in an indicator picture which is 1 where the pixels are missing in badicture
mask = double(imread('badpixels.tif')); % hole = white = 0, else = black = 1
% figure(6)
% image(mask * 255);
% colormap(gray(256)); 

% Please initialise your variables here
total_iterations = 2000;
alpha = 1.0;

% Initialise your iterations here ....
restored = badpic;
restored2 = badpic; 
restored20 = badpic;
restored20_2 = badpic;

err = zeros(1, total_iterations);
err2 = zeros(1, total_iterations);


figure(1);           
image(original);
title('Original');
colormap(gray(256));

figure(2);          
image(badpic);
title('Corrupted picture');
colormap(gray(256));

[j, i] = find(mask ~= 0); %[pixel rows , pixel columns]
N = length(j); %lenght_pixels = length(j)
missing_pixels = find(mask ~= 0);
Error = zeros(675, 1187);

%SOR function when f(x, y) = 0 and with forcing function f
for iteration = 1 : total_iterations
    for pixel = 1 : N 
        
        x = j(pixel);
        y = i(pixel); 
        left = restored(x - 1, y);
        right = restored(x + 1, y);
        above = restored(x, y + 1);
        below = restored(x, y - 1);
        current = restored(x, y);        
        
        Error(x, y) = left + right + below + above - 4 * (current);
        
        left2 = restored2(x - 1, y);
        right2 = restored2(x + 1, y);
        above2 = restored2(x, y + 1);
        below2 = restored2(x, y - 1);
        current2 = restored2(x, y);  
        
        Error2(x, y) = left2 + right2 + below2 + above2...
            - 4 * (current2) - f(x,y);
        
           
        if (iteration == 20)
               
            restored20(x, y) = current+ (alpha * (Error(x, y))/4);
            restored20_2(x,y) = current + (alpha * (Error(x, y))/4);
               
        else

        restored(x, y) = restored(x, y) + (alpha * (Error(x, y))/4);
        
         restored2(x, y) = restored2(x, y) + (alpha * (Error2(x, y))/4);
           
        end
        
    end
    
    difference = original(missing_pixels) - restored(missing_pixels); 
    err(iteration) = std(difference);
    
    difference2 = original(missing_pixels) - restored2(missing_pixels);
    err2(iteration) = std(difference2);
    
end

% Display the restored image in Figure 3 (This does NOT use the forcing function)
figure(3);
image(restored);
title('Restored Picture');
colormap(gray(256));
Error2 = zeros(675, 1187);

% Display your restored image with forcing function as Figure 4
figure(4);
image(restored2);
title('Restored Picture (with F)');
colormap(gray(256));

% And plot your two error vectors versus iteration
figure(5);  
plot((1: total_iterations), err, 'r-',(1: total_iterations), err2, 'b-', 'linewidth', 2.0);
legend('No forcing function', 'With forcing function');
xlabel('Iteration', 'fontsize', 20);
ylabel('Std Error', 'fontsize', 20);



