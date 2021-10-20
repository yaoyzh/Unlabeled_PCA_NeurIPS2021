function image_face(xj, f_id, h, w, img_title)

Imagej = reshape(xj, [h, w]);
f = figure;
image(Imagej); 
colormap(gray);
f.Units = 'centimeters';
f.Position = [2+3*f_id 15 2 3];
title(img_title);
set(gca, 'FontSize', 12, 'Fontname','times new Roman'); 
xticks([]);
yticks([]); 
yticklabels([]);
xticklabels([]);

end