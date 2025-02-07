close all;
clc;
 
n = 20;
nv = 12;


all_images = dir('input_images/');           %% 读取\input_images目录下所有图象文件。可在MATLAB环境下直接键入all_images看该结构体的结构。注意，果有99个图片文件，则all_images中含有101个分量，因为还包括"."和".."

cd('input_images/');
image_0 = imread(all_images(3).name);        %% 读取第一幅图片，注意序号从"3"开始。
cd('../');

[row, col, channel] = size(image_0);         %% 读取图片的大小、颜色信息
Y = zeros(row*col, length(all_images)-2);    %% 为Y变量预留内存空间。
if (channel == 3)                            %% channel返回3说明是颜色图片，否则是灰度图片 
    is_color = 1;
else
    is_color = 0;
end
 
for k = 3:length(all_images)
    
    %% 读取第k幅图片

    file_name = all_images(k).name;
    cd('input_images/');    
    image = imread(file_name,'bmp');
    cd('../');
    
    if (is_color)
        image = rgb2gray(image);             %% 如果是颜色图片，则要转化为灰度图片
    end
            
    Y(:,k-2) = double(reshape(image,row*col,1));    %% 将图片的矩阵表达转化为向量表达，即将一个120*170的矩阵转化为一个20400*1的列矩阵，并作为Y的第k-2列。
    
end


 
%%% Add your training code here
%%% To get Ahat, Chat, ......     
tau = size(Y,2);
Ymean = mean(Y,2);
Y = Y - Ymean * ones(1,tau);

[U,S,V] = svd(Y,0);
Chat = U(:,1:n);
Xhat = S(1:n,1:n) * V(:,1:n)';
x0 = Xhat(:,1);
Ahat = Xhat(:,2:tau) * pinv(Xhat(:,1:(tau-1)));

Vhat = Xhat(:,2:tau) - Ahat*Xhat(:,1:(tau-1));
[Uv,Sv,Vv] = svd(Vhat,0);
Bhat = Uv(:,1:nv) * Sv(1:nv,1:nv) / sqrt(tau-1);

% %%% Add your test code here

tau = 2000;
X = x0;

WriterObj=VideoWriter('test.avi');
open(WriterObj);
 
for k = 1:tau
     
     X = Ahat * X + Bhat * randn(nv,1);
     I = Chat * X + Ymean;
     
     I = floor(I);
     
     syn_img = reshape(I,[row,col]);
     
     imshow(syn_img,[0,255]);
     
     saveUI = strcat('output_images/', num2str(k), '.bmp');
     saveplace = strcat('output_images/', num2str(k));
     saveas(gcf, saveplace, 'bmp');
     frame = imread(saveUI);
     writeVideo(WriterObj,frame);
     
     title(strcat('Frame ',num2str(k)));
     pause(0.01);
end

close(WriterObj);
