Sr=zeros(15,77760); % Represenatative image matrix
Edis=zeros(15,1); % Euclidian distance vector
train_correct = 0; % No.of correct match in train set
test_correct = 0; % No.of correct match in test set
StdS = zeros(15,77760);
%Reading train set: 11 images of 15 subjects :
%cl,glass,happy,ll,ng,norm,rightlight,sad,sleepy,surprised,wink
for i=1:15
 afile = sprintf('cl (%d).png',i);
 bfile = sprintf('glass (%d).png',i);
 cfile = sprintf('happy (%d).png',i);
 dfile = sprintf('ll (%d).png',i);
 efile = sprintf('ng (%d).png',i);
 ffile = sprintf('norm (%d).png',i);
 gfile = sprintf('rightlight (%d).png',i);
 hfile = sprintf('sad (%d).png',i);
 ifile = sprintf('sleepy (%d).png',i);
 jfile = sprintf('surprised (%d).png',i);
 kfile = sprintf('wink (%d).png',i);
 imgA = imread(afile);
 imgB = imread(bfile);
 imgC = imread(cfile);
 imgD = imread(dfile);
 imgE = imread(efile);
 imgF = imread(ffile);
 imgG = imread(gfile);
 imgH = imread(hfile);
 imgI = imread(ifile);
 imgJ = imread(jfile);
 imgK = imread(kfile);
 if i == 1
 S = [reshape(imgA,[],1) reshape(imgB,[],1) reshape(imgC,[],1) reshape(imgD,[],1)
reshape(imgE,[],1) reshape(imgF,[],1) reshape(imgG,[],1) reshape(imgH,[],1) reshape(imgI,[],1)
reshape(imgJ,[],1) reshape(imgK,[],1)];
 else
 S = [S reshape(imgA,[],1) reshape(imgB,[],1) reshape(imgC,[],1) reshape(imgD,[],1)
reshape(imgE,[],1) reshape(imgF,[],1) reshape(imgG,[],1) reshape(imgH,[],1) reshape(imgI,[],1)
reshape(imgJ,[],1) reshape(imgK,[],1)]; 
 end
end
%Finding representative image for 15 subjects
for i=0:14
 S1 = S(:,(i*11+1):(i*11+11));
 M2=mean(S1,2); %Mean of each pixel
 M = repmat(M2, [1, 11]);
 S1= 255*im2double(S1);
 S1s=S1-M; %Mean shifted data
 CovS1 = cov(S1s);
 [V,imgD] = eig(CovS1);
 %last eigenvector corresponds to the higgest eigenvalue
 %hence 11 images are compressed to a single representative image.
 Sr(i+1,:)=(S1s*V(:,11)+ M2)';
end
%Finding Standard deviation of error in the train images and representative
%image
for i=0:14
 for j=1:11
 StdS(i+1,:) = StdS(i+1,:) + (Sr(i+1,:)- 255*im2double(S(:,i*11+j))').^2;
 end
 StdS(i+1,:) = StdS(i+1,:)/5;
 for k=1:77760
 if StdS(i+1,k) == 0
 %weighting won't be possible for if stdS == 0
 %hence 0 is replaced with min of StdS exept 0, ie. 0.1746
 StdS(i+1,k) = 0.1746;
 end
 end
end
%testing model for training image set : 11 * 15
for i=0:14
 for j=1:11
 for k=0:14
 Edis(k+1)=sum(((Sr(k+1,:)-255*im2double(S(:,i*11+j))').^2)./StdS(i+1,:));
 end
 [H,J]=min(Edis);
 if J == (i+1)
 train_correct = train_correct + 1;
 end
 end
end
fprintf('No of correct match in train set = %d \n', train_correct);
fprintf('Accuracy in train set = %f %%\n', train_correct*100/165); 
