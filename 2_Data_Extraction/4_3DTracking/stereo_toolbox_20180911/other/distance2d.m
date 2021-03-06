function d = distance2d(r1, r2)
%DISTANCE2D  Compute distance of 2 2D points
%
%   D = DISTANCE2D(R1, R2) computes the distance D of R1 to R2 in units of
%   R1 and R2's unit. R1 can be an Nx2 matrix of 2D points, R2 has to be a
%   single point.

%                                                       created: -unknown-

    d = ((r1(:,1)-r2(1)).^2 + (r1(:,2)-r2(2)).^2).^0.5;