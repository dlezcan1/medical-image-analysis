%% prob2.m
%
% this is to answer problem 2 in the homework
%
% - written by: Dimitri Lezcano

function prob2
    %% prob c 
    imga = getim('img_a.raw');
    imga_mask = getim('img_a_seg-mask.raw');
    imgb = getim('img_b.raw');
    
    idx = knnsearch(imga(:), imgb(:));
    
    imgb_mask = reshape(imga_mask(idx), size(imga_mask));
    
    fig_c = figure(1);
    imshow(imgb_mask, [0, 3]);
    title('imgb mask');
    
    saveas(fig_c, 'prob2c.png');
    disp("Saved figure: 'prob2c.png'");
    
    %% prob d
    imga_fg = imga(imga > 0);
    imgb_fg = imgb(imgb > 0);
    
    % fit GMM model
    gm = fitgmdist(imga_fg(:), 3);
    
    % plot density estimate
    imga_pdf = reshape(pdf(gm, imga(:)), size(imga));
    
    fig_d_pdf = figure(2);
    imshow(imga_pdf, [0, max(imga_pdf(:))]);
    title('PDF of imga');
    saveas(fig_d_pdf, 'prob2d_pdf.png');
    
    % plot posterior probability
    imga_posterior = reshape(posterior(gm, imga(:)), [size(imga), 3]);
    imga_posterior(repmat(imga == 0, 1, 1, 3)) = 0;
    
    fig_d_post = figure(3);
    imshow(imga_posterior);
    title('Posterior probability of imga');
           
    saveas(fig_d_post, 'prob2d_posterior.png');
    
    % plot hard assignments
    [~, imga_hard] = max(imga_posterior, [], 3);
    imga_hard(imga == 0) = 0;
    
    fig_d_hard = figure(4);
    imshow(imga_hard, [0,3]);
    title('imga hard assignment GMM');
    
    saveas(fig_d_hard, 'prob2d_hard.png');
    

end

%% Helper functions
function y = getim(filename)
    fid=fopen(filename);
    if fid > -1
        y=fread(fid,[256 256],'char');
        fclose(fid);
        y=y';
    else
        message = 'I/O error: File could not be opened'
    end
end