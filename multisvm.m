function [itrfin] = multisvm( T,C,test )
%Inputs: T=Training Matrix, C=Group, test=Testing matrix
%Outputs: itrfin=Resultant class

itrind=size(test,1);%no of pixels feature vector matrix of test image
itrfin=[];
Cb=C;%check matrix with values 1,2,3,4,5,6,7
Tb=T;%matrix values of feature vector of training database
for tempind=1:itrind% iterating from starting pixel value to total no pixels of test image
    tst=test(tempind,:);
    C=Cb;%check matrix
    T=Tb;%training matrix
    u=unique(C);%unique data values that are not similar is stored
    N=length(u);%size of the unique matrix
    %doing this step to see how unsimilar the test and trained image is
    c4=[];%empty matrix1
    c3=[];%empty matrix2
    j=1;%loop iterators
    k=1;%loop iterators
    if(N>2)%condition if unique matrix is mostly unsimilar with a value greater than 2
        itr=1;%iterator
        classes=0;%variable to classify class of soil
        cond=max(C)-min(C);%max value of check matrix - least value of check matrix[7-1= 6]
        while((classes~=1)&&(itr<=length(u))&& size(C,2)>1 && cond>0)
            c1=(C==u(itr));%if unique matrix of 1 itr is equal with trained database itr store in c1
            newClass=c1;%to group them as new class with that matrix
            %svmStruct = svmtrain(T,newClass,'kernel_function','rbf'); % I am using rbf kernel function, you must change it also
            svmStruct = svmtrain(T,newClass);%to train training matrix images with new grouped class
            classes = svmclassify(svmStruct,tst);% to check the test matrix with svmStruct output and store res in classes
        
            % This is the loop for Reduction of Training Set
            for i=1:size(newClass,2)%itr
                if newClass(1,i)==0;%if the new class matrix values are not unique and matches values
                    c3(k,:)=T(i,:);%copy the training database class of images matrix
                                   %values with new empty matrix c3
                    k=k+1;%increment until last pixel value
                end
            end
        T=c3;%update training matrix database with mostly matched image matrix database
        c3=[];%empty the matrix
        k=1;% itr
        
            % This is the loop for reduction of group
            for i=1:size(newClass,2)%itr
                if newClass(1,i)==0;%if the new group of class are not unique and matches value 
                    c4(1,j)=C(1,i);%copy the group of training database class of image mat values in new matrix c4 
                    j=j+1;%increment till last pixel value
                end
            end
        C=c4;%update group matrix variable with matched image matrix value
        c4=[];%empty the matrix
        j=1;%itr
        
        cond=max(C)-min(C); % Condition for avoiding group 
                            %to contain similar type of values 
                            %and the reduce them to process
        
            % This condition can select the particular value of iteration
            % base on classes
            if classes~=1
                itr=itr+1;
            end    
        end
    end
             % these conditions once again used for dimensionality
             % reduction to select particular class based on matched features.
valt=Cb==u(itr);% This logic is used to allow classification[if both unique and group is equal]
val=Cb(valt==1);%if both the matrix is equal the values of first dimension is returned 		
val=unique(val); % again checks for uniqueness among the matrix values
itrfin(tempind,:)=val;  %final group of trained database matrix is stored ex : 1-clay,2- clay peat
end

end

