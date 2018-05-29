close all;
 
all_images = dir('input_images/');           %% ��ȡ\input_imagesĿ¼������ͼ���ļ�������MATLAB������ֱ�Ӽ���all_images���ýṹ��Ľṹ��ע�⣬����99��ͼƬ�ļ�����all_images�к���101����������Ϊ������"."��".."

cd('input_images/');
image_0 = imread(all_images(3).name);        %% ��ȡ��һ��ͼƬ��ע����Ŵ�"3"��ʼ��
cd('../');

[row, col, channel] = size(image_0);         %% ��ȡͼƬ�Ĵ�С����ɫ��Ϣ
Y = zeros(row*col, length(all_images)-2);    %% ΪY����Ԥ���ڴ�ռ䡣
if (channel == 3)                            %% channel����3˵������ɫͼƬ�������ǻҶ�ͼƬ 
    is_color = 1;
else
    is_color = 0;
end
 
for k = 3:length(all_images)
    
    %% ��ȡ��k��ͼƬ

    file_name = all_images(k).name;
    cd('input_images/');    
    image = imread(file_name,'bmp');
    cd('../');
    
    if (is_color)
        image = rgb2gray(image);             %% �������ɫͼƬ����Ҫת��Ϊ�Ҷ�ͼƬ
    end
            
    Y(:,k-2) = double(reshape(image,row*col,1));    %% ��ͼƬ�ľ�����ת��Ϊ����������һ��120*170�ľ���ת��Ϊһ��20400*1���о��󣬲���ΪY�ĵ�k-2�С�
    
end

Ymean = mean(Y,2);
Y = Y - Ymean * ones(1,size(Y,2));
 

%%% Add your training code here
%%% To get Ahat, Chat, ......     






% %%% Add your test code here
% X = x0;
% 
% for k = 1:1000
%     
%     X = Ahat * X + Bhat * randn(nv,1);
%     I = Chat * X + Ymean;
%     
%     I = floor(I);
%     
%     syn_img = reshape(I,[row,col]);
% 
%     imshow(syn_img,[0,255]);
%     title(strcat('Frame ',num2str(k)));
%     pause(0.01);
% end

