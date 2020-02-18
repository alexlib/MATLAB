%this code organizes a text file (Tecplot format) in Matlab matrix
%format.
%Created by Ricardo Mejia-Alvarez. Urbana, IL. 03/03/08
%modified:  07/10/08
%           11/14/08
%           09/29/09
%           06/21/2010

%input:
%path: full path for the file to analyze

%outputs:
%nc: number of columns in the file, which will be the number of matrices
%generated by this function
%I: number of columns in the matrices
%J: number of rows in the matrices
%Dx and Dy: grid spacings in each coordinate
%U: cell array of matrices containing the data


function [nc,I,J,Dx,Dy,U] = matrixCell(path)

m = fopen(path,'r');      %open the file selected

fgets(m);  %discards all the characters before the numerical data.
first = fgets(m);   %reads the first line of data
first = str2num(first); %#ok<ST2NM>
nc = length(first); %calculates the number of columns in the files
                                            
C = textscan(m,'%f64','delimiter',','); %reads the numerical data from the file
A = C{:};     %saves the data in a vector
A = [first' ; A];

A = reshape(A,nc,length(A)/nc)';

A = sortrows(A,[1,2]);
J = find(A(1,1)-A(:,1) == 0, 1 , 'last');
Dy = abs( A(2,2) - A(1,2) );

A = sortrows(A,[2,1]);
I = find(A(1,2)-A(:,2) == 0, 1 , 'last');
Dx = abs( A(2,1) - A(1,1) );

U = cell(1 , nc);

for k = 1 : nc
    U{k} = reshape(A(:,k),I,J)';
end


fclose(m);      %closes the current file




end %end of the function