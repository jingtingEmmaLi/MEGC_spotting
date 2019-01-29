%% vetor angle
function angle = vectorAngle(A,B)
produit = dot(A,B);
normPro = norm(A)*norm(B);
cosAB = produit/normPro;
angleRadian = acos(cosAB);
angle = angleRadian*180/pi;
end