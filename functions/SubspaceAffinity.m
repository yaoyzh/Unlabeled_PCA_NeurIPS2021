function [largestDeg] = SubspaceAffinity(U1, U2)

d = min(size(U1, 2), size(U2, 2));
[U1, ~, ~] = svd(U1);
[U2, ~, ~] = svd(U2);

B1B2 = U1(:, 1:d)' * U2(:, 1:d);
costhetas_B1B2 = svd(B1B2);
largestDeg = acosd(min(costhetas_B1B2));

end